require 'fileutils'
require 'uri'
require 'rest-client'
module JasperserverRails
  class Jasperserver
    attr_accessor :report, :format

    def initialize(&block)
      instance_eval(&block) if block_given?
      login
    end

    def params=(value)
      @params = value.collect { |key, value| [key, value] }
    end

    def params
      URI.encode_www_form(@params)
    end

    def generate_report(&block)
      instance_eval(&block) if block_given?
      login
      request_from_server
    end

    def run_report(filename, &block)
      FileUtils.mkdir_p(File.expand_path(filename).split('/')[0..-2].join('/'))
      f = File.new(filename, 'wb')
      f.write(generate_report(&block).body)
      f.close
    end

    def get_data(&block)
      generate_report(&block).body
    end

    private

    def config
      JasperserverRails.config.server
    end

    def login
      @cookie ||= RestClient.post(login_url, login_params).cookies
    end

    def login_params
      {
        j_username: config[:username],
        j_password: config[:password]
      }
    end

    def login_path
      ['rest', 'login'].join '/'
    end

    def login_url
      URI.join(config[:url], login_path).to_s
    end

    def report_path
      ['rest_v2', 'reports', "#{report}.#{format}?#{params}"].join '/'
    end

    def request_from_server
      RestClient.get(report_url, { cookies: @cookie })
    end

    def report_url
      URI.join(config[:url], report_path).to_s
    end
  end
end
