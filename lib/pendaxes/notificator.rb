require_relative 'pending_manager'
require_relative 'defaults'

module Pendaxes
  class Notificator
    include PendingManager
    extend Defaults

    def initialize(config={})
      @config = self.class.defaults.merge(config)
      @pendings = []
    end

    def notify
    end
  end
end
