require 'jasperserver-rails/engine'
require 'jasperserver-rails/configuration'
require 'jasperserver-rails/jasperserver-dsl'

module JasperserverRails
  class << self
    def configure
      @config = Configuration.new
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end
