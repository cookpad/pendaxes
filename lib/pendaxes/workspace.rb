require_relative 'defaults'
require 'hashr'

module Pendaxes
  class Workspace
    extend Defaults

    def initialize(config={})
      @config = Hashr.new(self.class.defaults.merge(config))
    end

    def clone
      FileUtils.remove_entry_secure(path) if File.exist?(path)
      git "clone", @config.repository, path
    end

    def update
      clone unless File.exist?(path)

      dive do
        git "fetch", "origin"
        git "reset", "--hard", @config.branch || "FETCH_HEAD"
      end
    end

    def path; @config.path; end

    def dive
      Dir.chdir(path) do
        yield
      end
    end

    def git(*args)
      system(@config.git || "git", *args)
    end
  end
end
