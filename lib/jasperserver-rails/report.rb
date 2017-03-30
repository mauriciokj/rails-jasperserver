# module JasperserverRails
#   class Report
#
#     private
#
#     def config
#       JasperserverRails.config.server
#     end
#
#     def login
#       @cookie ||= RestClient.post(login_url, login_params).cookies
#     end
#
#     def login_params
#       {
#         j_username: config[:username],
#         j_password: config[:password]
#       }
#     end
#
#     def login_path
#       ['rest', 'login'].join '/'
#     end
#
#     def login_url
#       URI.join(config[:url], login_path).to_s
#     end
#
#     def path
#       ['rest_v2', 'reports', "#{report}.#{format}?#{params}"].join '/'
#     end
#
#     def request_from_server
#       RestClient.get(url, { cookies: @cookie })
#     end
#
#     def url
#       URI.join(config[:url], path).to_s
#     end
#   end
# end
