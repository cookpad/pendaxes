require_relative 'pending_manager'
require_relative 'defaults'

module Pendaxes
  class Detector
    extend Defaults

    def initialize(workspace, config={})
      @config = self.class.defaults.merge(config)
      @pendings = []
    end

    def detect
    end
  end
end
