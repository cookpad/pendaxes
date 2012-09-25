require_relative '../notificator'
require 'mail'

module Pendaxes
  class Notificator
    class Mail < Notificator
      defaults reporter: {use: :text}, blacklist: []

      def notify
        if @config.to
          deliver(pendings, @config.to)
        else
          pendings.group_by {|pending| pending[:commit][:email] }.each do |email, pends|
            deliver(pends, email)
          end
        end
      end

      def whitelist
        if @config.whitelist
          @whitelist ||= process_email_filter(@config.whitelist)
        else
          nil
        end
      end

      def blacklist
        @blacklist ||= process_email_filter(@config.blacklist)
      end

      private

      def deliver(pends,email)
        real_email = (@config.alias || {})[email] || email
        return nil if blacklist.match?(real_email) || (whitelist && !whitelist.match?(real_email))

        mail = ::Mail.new
        mail.from = @config.from
        mail.to = real_email
        mail.subject = "[Pendaxes] Your #{pends.size} pending tests are waiting to be fixed"
        mail.body = report_for(pends)
        mail.content_type = 'text/html; charset=utf-8' if reporter.html?

        if @config.delivery_method
          mail.delivery_method @config.delivery_method.to_sym, @config.delivery_options || {}
        end

        @config.out.puts mail.inspect if @config.out

        mail.deliver
      end

      def process_email_filter(list)
        filter = list.map do |email|
          if %r{^/(.*)/$} === email
            Regexp.new($1)
          else
            email
          end
        end
        class << filter
          def match?(email)
            self.any? do |condition|
              condition.is_a?(Regexp) ? condition === email : condition == email
            end
          end
        end
        filter
      end
    end
  end
end
