require 'fileutils'
require 'uri'
require 'rest-client'
module JasperserverRails
  class Login
    def initialize(cookies = nil)
      @cookies = cookies
    end

    def cookies
      if method == "post"
        @cookies ||= RestClient.post(url_post, params).cookies
      else
        @cookies ||= RestClient.get(url_get).cookies
      end
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

    def path_get
      config[:url_login] + '?' + params.to_query
    end

    def path_post
      config[:url_login]
    end

    def method
      config[:method]
    end

    def url_get
      URI.join(config[:url], path_get).to_s
    end

    def url_post
      URI.join(config[:url], path_post).to_s
    end
  end
end
