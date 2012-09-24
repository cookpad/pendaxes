require_relative '../reporter'
require 'haml'
require 'digest/md5'
require 'cgi'

module Pendaxes
  class Reporter
    class Haml < Reporter
      defaults commit_url: nil,
               file_url: nil,
               report_url: nil,
               gravatar: true,
               older_first: true,
               template: "#{File.dirname(__FILE__)}/template.haml"

      def report
        haml = ::Haml::Engine.new(File.read(@config.template))
        haml.render(binding, config: @config)
      end

      def self.html?; true; end

      private

      def relative_time(time, from = Time.now)
        diff = from - time
        return "in the future" if diff < 0
        case diff
        when 0..10
          "Just now"
        when 11..60
          "in a minute"
        when 61...3600
          "%.1f minutes ago" % (diff/60)
        when 3600...86400
          "%.1f hours ago" % (diff/3600.0)
        when 86400...604800
          "%.1f days ago" % (diff/86400.0)
        when 604800...2419200
          "%.1f weeks ago" % (diff/604800.0)
        when 2419200...31556926
          "%.1f months ago" % (diff/2419200.0)
        else
          "%.1f years ago" % (diff/31556926.0)
        end
      end
    end
  end
end
