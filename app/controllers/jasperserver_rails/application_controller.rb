module JasperserverRails
  class ApplicationController < ::ApplicationController
    def current_cookies
      session[:jasper_cookies]
    end

    def current_login
      Login.new(current_cookies)
    end
  end
end
