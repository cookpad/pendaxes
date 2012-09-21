require_relative 'pending_manager'
require_relative 'defaults'

module Pendaxes
  class Reporter
    include PendingManager
    extend Defaults

    def initialize(config={})
      @config = self.class.defaults.merge(config)
      @pendings = []
    end

    def report
    end

    def html?
      false
    end
  end
end
