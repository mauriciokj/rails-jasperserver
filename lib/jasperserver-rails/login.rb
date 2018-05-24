require 'fileutils'
require 'uri'
require 'rest-client'
module JasperserverRails
  class Login
    def cookies
      RestClient.post(url, params).cookies
    end

    private

    def config
      JasperserverRails.config.server
    end

    def params
      {
        j_username: config[:username],
        j_password: config[:password]
      }
    end

    def path
      ['rest', 'login'].join '/'
    end

    def url
      URI.join(config[:url], path).to_s
    end
  end
end
