require_relative '../reporter'
require 'json'

module Pendaxes
  class Reporter
    class JSON < Reporter
      def report
        {pendings: pendings.sort_by{|x| x[:commit][:at] }}.to_json
      end
    end
  end
end
