require 'hashr'

module Pendaxes
  module PendingManager
    def add(pending={})
      case pending
      when Array
        @pendings.push *pending.map{|x| Hashr.new(x) }
      when Hash
        @pendings << Hashr.new(pending)
      end
    end

    def pendings
      if @config.include_allowed
        all_pendings
      else
        @pendings.reject(&:allowed)
      end
    end

    def all_pendings
      @pendings
    end

    def reset
      @pendings = []
    end
  end
end
