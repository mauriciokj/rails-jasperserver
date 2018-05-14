require 'fileutils'
require 'uri'
require 'rest-client'

module JasperserverRails
  class Report < Base

    def params=(value)
      @params = value.collect { |key, value| [key, value] }
    end

    def params
      URI.encode_www_form(@params)
    end

    def write(filename)
      FileUtils.mkdir_p(File.expand_path(filename).split('/')[0..-2].join('/'))
      f = File.new(filename, 'wb')
      f.write(data)
      f.close
    end

    def data
      generate.body
    end

    private

    def generate
      request_from_server
    end

    def path
      ['rest_v2', 'reports', "#{report}.#{format}?#{params}"].join '/'
    end

    def request_from_server
      RestClient.get(url, { cookies: cookie })
    end
  end
end
