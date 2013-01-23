require_relative '../notificator'

module Pendaxes
  class Notificator
    class Terminal < Notificator
      defaults to: $stdout, reporter: {use: :text}

      def notify
        io = @config.to
        io.puts report_for(pendings)
      end
    end
  end
end
