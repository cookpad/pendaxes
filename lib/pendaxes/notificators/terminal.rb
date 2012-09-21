module Pendaxes
  class Notificator
    class Terminal < Notificator
      defaults to: $stdout

      def notify
        io = @config.to
        pendings.group_by{|x| "#{x[:commit][:name]} <#{x[:commit][:email]}>" }.each do |name, pends|
          io.puts "#{name}:"
          pends.sort_by {|x| -(Time.now - x[:commit][:at]) }.each do |pending|
            io.puts "  #{pending[:example][:file]}:#{pending[:example][:line]} - #{pending[:example][:message]} (@ #{pending[:commit][:sha]} #{pending[:commit][:at]})"
          end
          io.puts
        end
      end
    end
  end
end
