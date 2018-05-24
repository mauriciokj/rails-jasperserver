module JasperserverRails
  class Configuration
    attr_accessor :servers, :config_file

    def cookie
      @@cookie ||= Login.new.cookies
    end

    def server
      servers[Rails.env.to_sym]
    end

    def servers
      @servers ||= read_config_file
    end

    def read_config_file
      YAML.load(File.read(Rails.root.join('config', 'jasperserver.yml'))).deep_symbolize_keys
    end
  end
end
