module JasperserverRails
  class Base
    include ActiveSupport::Rescuable

    attr_accessor :report, :format, :login

    rescue_from RestClient::Unauthorized, with: :logout_with_expection

    def initialize(options)
      options.each { |key, value| self.send("#{key}=", value) }
    end

    def cookies
      login.cookies
    end

    def login
      @login ||= Login.new
    end

    protected

    def path
      raise NotImplementedError
    end

    def config
      @config ||= JasperserverRails.config.server
    end

    def logout
      self.login = nil
    end

    def logout_with_expection
      logout
      raise Unauthorized
    end

    def url
      URI.join(config[:url], path).to_s
    end
  end
end
