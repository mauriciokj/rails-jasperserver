module JasperserverRails
  class Base
    include ActiveSupport::Rescuable

    attr_accessor :report, :format

    rescue_from RestClient::Unauthorized, with: :logout

    def initialize(options)
      options.each { |key, value| self.send("#{key}=", value) }
    end

    protected

    def path
      raise NotImplementedError
    end

    def config
      @config ||= JasperserverRails.config.server
    end

    def cookie
      @cookie ||= JasperserverRails.config.cookie
    end

    def logout
      @cookie = nil
      JasperserverRails.config.logout
    end

    def url
      URI.join(config[:url], path).to_s
    end
  end
end
