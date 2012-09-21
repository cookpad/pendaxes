require_relative 'pending_manager'
require_relative 'defaults'
require_relative 'finder'
require 'hashr'

module Pendaxes
  class Reporter
    include PendingManager
    extend Defaults
    extend Finder
    find_in 'pendaxes/reporters'

    defaults include_allowed: true

    def initialize(config={})
      @config = Hashr.new(self.class.defaults.merge(config))
      @pendings = []
    end

    def report
    end

    def html?
      false
    end
  end
end
