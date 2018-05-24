module JasperserverRails
  class ReportExecutionDetails < Base
    attr_accessor :request_id

    def perform
      response = details
      JSON.parse(response.body)
    end

    private

    def details
      begin
        RestClient.get(url, { cookies: cookie, accept: :json })
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end

    def path
      ['rest_v2', 'reportExecutions', self.request_id].join '/'
    end
  end
end
