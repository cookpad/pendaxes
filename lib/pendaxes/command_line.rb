require_relative "./config"
require_relative "./workspace"
require_relative "./detector"
require_relative "./reporter"
require_relative "./notificator"
require 'yaml'
require 'optparse'

module Pendaxes
  class CommandLine
    DEFAULT_CONFIG_FILE = ".pendaxes.yml"

    def initialize(*args)
      @args = args.dup
      @config = nil
    end

    def config
      return @config if @config
      return nil if @args.empty? && !File.exist?(DEFAULT_CONFIG_FILE)

      @config = Config.new(YAML.load_file(@args.first || DEFAULT_CONFIG_FILE))
    end

    def write_default_config(options={})
      options[:to] ||= DEFAULT_CONFIG_FILE
      workspace = (options[:path] || options[:repository])
      open(options[:to], 'w') do |io|
        io.puts <<-EOC
# Pendaxes default configuration file.
# See https://github.com/cookpad/pendaxes/wiki/Configuration for detail.

##
# for automatic git-pulling. recommend to set if you run periodically.
#
# path:       path to working copy to use.
#             if not exist, pendaxes will clone automatically from `repository`.
#             PENDAXES WILL DO "git reset --hard".
#             MAKE SURE path TO BE NOT SAME WITH working copy you use.
#
# repository: remote url of repository.
#             if `path` doesn't exist, will automatically cloned from specified url.
##

#{workspace            ? '' : '# '}workspace:
#{options[:path]       ? '' : '# '}  path: #{options[:path] || '/tmp/repository'}
#{options[:repository] ? '' : '# '}  repository: #{options[:repository] || "git@github.com:cookpad/pendaxes.git"}

##
# Settings of notification.
# See https://github.com/cookpad/pendaxes/wiki/Configuration for detail.
##

notifications:
  - use: file       # write report to file.
    to: report.html # path to write.
    reporter:
      use: haml
#  - use: mail      # send mails to each committer of pending.
#    reporter:
#      use: haml
#    from: no-reply@example.com
#    delivery_method: sendmail
#  - use: terminal # show pendings on STDOUT.

##
# Settings for pending detection
##

detector:
  use: rspec # Use rspec detector. Currently only rspec is available.
  pattern:   # pattern of rspec file. this will be passed right after of "git grep --".
  - '*_spec.rb'
#  - 'spec/**/*.rb'
        EOC
      end

      puts "Just written default config file to #{options[:to]} !"
      if workspace
        puts "\nWith automatic git-pulling enabled:"

        if options[:repository] && options[:path]
          puts "  * using #{options[:repository]}"
          puts "  * will cloned at #{options[:path]}"

          if File.exist?(options[:path])
            puts "WARNING: #{options[:path]} already exists! Pendaxes does `git reset --hard`, be careful!"
          end
        elsif options[:path]
          puts "  * using working copy on #{options[:path]}"
          puts "WARNING: #{options[:path]} doesn't exist, you have to clone." unless File.exist?(options[:path])
        elsif options[:repository]
        end
      else
        puts <<-EOM

In default configuration, this will do:

1. Detect pendings
2. Write report file to "./report.html"

For more about configuration, see https://github.com/cookpad/pendaxes/wiki/Configuration !
        EOM

        if File.exist?(".git")
          puts "\nWARNING: this directory doesn't seem git working copy."
          puts "(Pendaxes works with git working copy.)"
        end
      end
    end

    def init
      write_default_config(to: @args[1], path: @args[2], repository: @args[3])
    end

    def usage
      puts <<-USAGE
Usage:
  pendaxes [config]
    config: (default = ./.pendaxes.yml)
            Path to config file to use.

  pendaxes --init [config] [path] [remote]

    config: (default = ./.pendaxes.yml)
            Where to write config file.
    path:   (optional)
            Path to working copy.
    remote: (optional)
            remote git url. if `path` doesn't exist,
            will be cloned from this onto `path`.

  pendaxes --help

    Show this help.
      USAGE
    end

    def workspace
      @workspace ||= Workspace.new(config.workspace || {path: Dir.pwd})
    end

    def update
      workspace.update if config.workspace
    end

    def detect
      @detector = Detector.find(config.detection.use.to_sym).new(@workspace, {out: $stdout}.merge(config.detection))
      @pendings = @detector.detect
    end

    def notify
      config.notifications.map{|x| Hashr.new(x) }.each do |notification|
        puts " * #{notification.use}"
        notificator = Notificator.find(notification.use.to_sym).new({out: $stdout}.merge(notification))
        notificator.add @pendings
        notificator.notify
      end
    end

    def run
      case @args.first
      when "--help"
        usage
      when "--init"
        init
      else
        unless config
          warn "./.pendaxes.yml not exists. showing usage..."
          usage
          return 1
        end

        if config.workspace
          puts "=> Update repository"
          update
        else
          warn "=> Using this working copy. To use automatic fetching, please fill 'workspace' in your config file."
          workspace # to initialize @workspace
        end

        puts "=> Detect pendings"
        detect

        puts "=> Send notifications"
        notify
      end

      0
    end

    class Oneshot
      def initialize(*args)
        @args = args
      end

      def run
        quiet = false
        path = Dir.pwd
        reporter = :text

        OptionParser.new do |opts|
          opts.on('-q', '--quiet', 'Turn off progress output.') do
            quiet = true
          end

          opts.on('-d DIR', '--repo DIR', 'Specify path to working copy of git.') do |dir|
            path = dir
          end

          opts.on('-r REPORTER', '--reporter REPORTER', 'Specify reporter') do |name|
            reporter = name.to_sym
          end

          opts.on_tail('--help', 'Show this help') do
            return usage
          end
        end.parse!(@args)

        if @args.empty?
          return usage
        end

        workspace = Workspace.new(path: path)

        files = workspace.dive do
          @args.map { |pattern|
            sub_files = Dir[pattern].map do |file_or_directory|
              if FileTest.file?(file_or_directory)
                file_or_directory
              elsif FileTest.directory?(file_or_directory)
                Dir[File.join(file_or_directory, '**', '*_spec.rb')]
              end
            end
            if sub_files.empty?
              abort "#{$0}: #{pattern}: No such file or directory"
            end
            sub_files
          }.flatten.map { |_| File.expand_path(_) }
        end

        $stderr.puts '=> Detecting...' unless quiet
        pendings = Detector.find(:rspec).new(workspace, out: quiet ? nil : $stderr, pattern: files).detect
        $stderr.puts '=> Total Result:' unless quiet

        notificator = Notificator.find(:terminal).new(
          out: $stdout, include_allowed: true,
          reporter: {use: reporter, include_allowed: true}
        )
        notificator.add pendings
        notificator.notify

        0
      end

      def usage
        $stderr.puts "Usage: pendaxes-oneshot [--help] [-q|--quiet] [-d DIR|--repo=DIR] [-r REPORTER|--reporter REPORTER] file_or_directory [file_or_directory ...]"
        $stderr.puts ""
        $stderr.puts "file_or_directory:"
        $stderr.puts "  File name, pattern or directory name to detect pendings."
        $stderr.puts "  if directory name given, will use *_spec.rb files in that directory (recursive)."
        $stderr.puts ""
        $stderr.puts "  NOTE: Files should be managed by git."
        $stderr.puts ""
        $stderr.puts "--help: Show this help and quit."
        $stderr.puts "--quiet, -q: Turn off progress output."
        $stderr.puts "--repo, -d: Specify path to working copy of git repository. (default: current directory)"
        $stderr.puts "--reporter, -r: Specify reporter. (Default: text)"
        0
      end
    end
  end
end
