require_relative '../notificator'

module Pendaxes
  class Notificator
    class Terminal < Notificator
      defaults to: $stdout, reporter: {use: :text}

      def notify
        io = @config.to
        pendings.group_by{|x| "#{x[:commit][:name]} <#{x[:commit][:email]}>" }.each do |name, pends|
          io.puts "#{name}:"
          io.puts
          io.puts report_for(pends)
          io.puts
        end
      end
    end
  end
end
