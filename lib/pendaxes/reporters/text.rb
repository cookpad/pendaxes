require_relative '../reporter'

module Pendaxes
  class Reporter
    class Text < Reporter
      def report
        pendings.group_by{|x| "#{x[:commit][:name]} <#{x[:commit][:email]}>" }.map do |name, pends|
           lines = pends.sort_by { |pending| pending[:commit][:at] }.map do |pending|
             "* #{pending[:example][:file]}:#{pending[:example][:line]} - #{pending[:example][:message]} (@ #{pending[:commit][:sha]} #{pending[:commit][:at]})"
           end.join("\n")

           "#{name}:\n\n#{lines}"
        end.join("\n\n")
      end
    end
  end
end
