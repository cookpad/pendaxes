require_relative 'pending_manager'
require_relative 'defaults'
require_relative 'finder'

module Pendaxes
  class Notificator
    include PendingManager
    extend Defaults
    extend Finder
    find_in 'pendaxes/notificators'

    def initialize(config={})
      @config = self.class.defaults.merge(config)
      @pendings = []
    end

    def notify
    end
  end
end
