require_relative '../reporter'

module Pendaxes
  class Reporter
    class Text < Reporter
      def report
        pendings.sort_by{|x| x[:commit][:at] - Time.now }.map {|pending|
          "* #{pending[:example][:file]}:#{pending[:example][:line]} - #{pending[:example][:message]} (@ #{pending[:commit][:sha]} #{pending[:commit][:at]})"
        }.join("\n")
      end
    end
  end
end
