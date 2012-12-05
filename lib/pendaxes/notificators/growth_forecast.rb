require_relative '../notificator'
require 'uri'
require 'net/http'

module Pendaxes
  class Notificator
    class GrowthForecast < Notificator
      defaults service_name: 'pendaxes',
               section_name: 'pendaxes',
               graph_name: 'pendaxes'

      def notify
        post_growth_forecast @config.service_name,
                             @config.section_name,
                             @config.graph_name,
                             @pendings.size
      end

      private

      def post_growth_forecast(service_name, section_name, graph_name, number, options = {})
        if @config.host
          uri = URI.parse("http://#{@config.host}/api/#{service_name}/#{section_name}/#{graph_name}")
          Net::HTTP.post_form(uri, options.merge(:number => number))
        end
      end
    end
  end
end
