require_relative '../notificator'

module Pendaxes
  class Notificator
    class File < Notificator
      defaults to: "report.txt", reporter: {use: :text}

      def notify
        @config.out.puts "   * writing report to #{@config.to}" if @config.out
        open(@config.to, 'w') do |io|
          io.puts report_for(pendings)
        end
      end
    end
  end
end
