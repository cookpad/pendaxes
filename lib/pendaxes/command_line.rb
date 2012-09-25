require_relative "./config"
require_relative "./workspace"
require_relative "./detector"
require_relative "./reporter"
require_relative "./notificator"

module Pendaxes
  class CommandLine
    def initialize(*args)
      @args = args
      @config = Config.new(YAML.load_file(args.first))
    end

    def run
      puts "=> Update repository"
      update

      puts "=> Detect pendings"
      detect

      puts "=> Send notifications"
      notify

      0
    end

    def update
      @workspace = Workspace.new(@config.workspace)
      @workspace.update
    end

    def detect
      @detector = Detector.find(@config.detection.use.to_sym).new(@workspace, {out: $stdout}.merge(@config.detection))
      @pendings = @detector.detect
    end

    def notify
      @config.notifications.map{|x| Hashr.new(x) }.each do |notification|
        puts " * #{notification.use}"
        notificator = Notificator.find(notification.use.to_sym).new({out: $stdout}.merge(notification))
        notificator.add @pendings
        notificator.notify
      end
    end
  end
end
