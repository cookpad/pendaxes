require "pendaxes/version"
require "pendaxes/command_line"

module Pendaxes
  class << self
    def run(*args)
      CommandLine.new(*args).run
    end
  end
end
