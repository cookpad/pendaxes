module Pendaxes
  class Workspace
    extend Defaults

    def initialize(config={})
      @config = self.class.defaults.merge(config)
    end
  end
end
