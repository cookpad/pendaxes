require_relative 'pending_manager'
require_relative 'defaults'
require_relative 'finder'

module Pendaxes
  class Reporter
    include PendingManager
    extend Defaults
    extend Finder
    find_in 'pendaxes/reporters'


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
