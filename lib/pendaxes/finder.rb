module Pendaxes
  module Finder
    def find(name)
      @finder_cache ||= {}
      path = case name
             when String
               name
             when Symbol
               "#{@finder_prefix || ""}#{name}"
             else
               raise ArgumentError, "name should be a kind of String or Symbol"
             end
      return @finder_cache[name] if @finder_cache[name]
      require path
      @finder_cache[name] = @finder_latest_inherited
    end

    def inherited(klass)
      @finder_latest_inherited = klass
    end

    def announce(name, klass)
      (@finder_cache ||= {})[name] = klass
    end

    def find_in(prefix)
      @finder_prefix = prefix + "/"
    end
    private :find_in
  end
end
