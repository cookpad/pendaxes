require_relative 'pending_manager'
require_relative 'defaults'
require_relative 'finder'
require 'hashr'

module Pendaxes
  class Notificator
    include PendingManager
    extend Defaults
    extend Finder
    find_in 'pendaxes/notificators'

    def initialize(config={})
      @config = Hashr.new(self.class.defaults.merge(config))
      @pendings = []
    end

    def notify
    end

    def report_for(pendings)
      reporter = Reporter.find(@config.reporter.name.to_sym).new(@config.reporter)
      reporter.add pendings
      reporter.report
    end
  end
end
