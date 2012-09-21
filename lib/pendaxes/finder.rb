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
      announce name, @finder_latest_inherited
    end

    def inherited(klass)
      if klass.name
        announce klass.name.gsub(/^.*::/,'').gsub(/.[A-Z]/){|s| s[0]+"_"+s[1] }.downcase.to_sym, klass
      end
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
