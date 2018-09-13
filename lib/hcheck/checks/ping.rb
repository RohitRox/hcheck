module Hcheck
  module Checks
    # ping check module
    # implements status
    # include ping check dependencies
    # returns ok only if the response code is 2** or 3**
    module Ping
      # @config { url }
      def status(config)
        request = build_request(config)

        case request.request_head(url.path)
        when Net::HTTPSuccess, Net::HTTPRedirection, Net::HTTPInformation
          'ok'
        else
          'bad'
        end
      rescue Net::ReadTimeout, Errno::ECONNREFUSED => e
        Hcheck.logger.error "[HCheck] Ping Fail #{e.message}"
        'bad'
      end

      def self.included(_base)
        require 'net/http'
      end

      def build_request(config)
        url = URI.parse(config[:url])
        req = Net::HTTP.new(url.host, url.port)
        req.use_ssl = true if url.scheme == 'https'
        req.read_timeout = 5 # seconds

        url.path = '/' if url.path.empty?
        req
      end
    end
  end
end
