require 'fileutils'
require 'uri'
require 'rest-client'
module JasperserverRails
  class Dsl
    class_eval do
      [:report, :format, :params].each do |method|
        define_method method do |arg|
          arg = arg.collect { |key, value| [key, value] } if method == :params
          instance_variable_set "@#{method}".to_sym, arg
        end

        define_method "get_#{method}" do
          instance_variable_get "@#{method}".to_sym
        end
      end
    end

    def initialize(&block)
      instance_eval(&block) if block_given?
      login
    end

    def generate_report(&block)
      instance_eval(&block) if block_given?
      login
      # Run report
      report_path = [
        'rest_v2',
        'reports',
        "#{self.get_report}.#{self.get_format}?#{URI.encode_www_form(self.get_params)}"
      ].join '/'
      RestClient.get(
        URI.join(
          config[:url],
          report_path
        ).to_s,
        { cookies: @cookie }
      )
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
      # login
      unless @cookie
        if method == "post"
          @cookie = RestClient.post(url_post, login_params).cookies
        else
          @cookie = RestClient.get(url_get).cookies
        end
      end
    end

    def login_params
      {
        j_username: config[:username],
        j_password: config[:password]
      }
    end

    def path_get
      config[:url_login] + '?' + login_params.to_query
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
