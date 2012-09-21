module Pendaxes
  module Defaults
    def defaults(h=nil)
      default_defaults = self.superclass.respond_to?(:defaults) ? self.superclass.defaults : {}
      @defaults ||= default_defaults
      if h
        @defaults = default_defaults.merge(h)
      end
      @defaults
    end
  end
end
