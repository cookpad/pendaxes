require_relative 'defaults'
require 'hashr'

module Pendaxes
  class Workspace
    extend Defaults

    def initialize(config={})
      @config = Hashr.new(self.class.defaults.merge(config))
    end

    def clone
      raise RemoteUrlMissing, "Set git remote url to workspace.repository, or clone to path yourself." unless @config.repository
      FileUtils.remove_entry_secure(path) if File.exist?(path)
      git "clone", @config.repository, path
    end

    def update
      clone unless File.exist?(path)

      dive do
        git "fetch", "origin"
        git "reset", "--hard", @config.branch || "origin/HEAD"
      end
    end

    def path; @config.path; end

    def dive
      Dir.chdir(path) do
        yield
      end
    end

    def git(*args)
      str = IO.popen([@config.git || "git", *args], 'r', &:read)
      $?.success? ? str : nil
    end
    
    class RemoteUrlMissing < Exception; end
  end
end
