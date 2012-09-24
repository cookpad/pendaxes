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
    defaults reporter: {name: :text}

    def initialize(config={})
      @config = Hashr.new(self.class.defaults.merge(config))
      @pendings = []
    end

    def notify
    end

    def reporter
      Reporter.find(@config.reporter.name.to_sym)
    end

    def report_for(pendings)
      r = reporter.new({include_allowed: true}.merge(@config.reporter))
      r.add pendings
      r.report
    end
  end
end
