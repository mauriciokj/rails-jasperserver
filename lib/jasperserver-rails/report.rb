require 'fileutils'
require 'uri'
require 'rest-client'

module JasperserverRails
  class Report
    attr_accessor :report, :format

    def initialize(options)
      options.each { |key, value| self.send("#{key}=", value) }
    end

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

    def config
      JasperserverRails.config.server
    end

    def cookie
      @cookie ||= Login.new.cookies
    end

    def generate
      request_from_server
    end

    def path
      ['rest_v2', 'reports', "#{report}.#{format}?#{params}"].join '/'
    end

    def request_from_server
      RestClient.get(url, { cookies: cookie })
    end

    def url
      URI.join(config[:url], path).to_s
    end
  end
end
