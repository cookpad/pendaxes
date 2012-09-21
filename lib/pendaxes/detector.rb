require_relative 'pending_manager'
require_relative 'defaults'
require_relative 'finder'

module Pendaxes
  class Detector
    extend Defaults
    extend Finder
    find_in 'pendaxes/detectors'

    def initialize(workspace, config={})
      @config = self.class.defaults.merge(config)
      @pendings = []
    end

    def detect
    end
  end
end
