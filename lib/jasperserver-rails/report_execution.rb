module JasperserverRails
  class ReportExecution < Base
    attr_accessor :fresh_data, :snapshot, :interactive
    attr_writer :params

    def initialize(options)
      super(options)
      self.fresh_data ||= true
      self.snapshot ||= false
      self.interactive ||= false
    end

    def perform
      response = schedule
      JSON.parse(response.body)
    end

    def schedule
      RestClient.post(url, request_params.to_json, { cookies: cookies, content_type: :json, accept: :json })
    end

    def params
      @params.collect  do |key, value|
        { name: key, value: [value] }
      end
    end

    protected

    def request_params
      {
        reportUnitUri: report,
        async: true,
        freshData: fresh_data.to_s,
        saveDataSnapshot: snapshot.to_s,
        outputFormat: format,
        interactive: interactive.to_s,
        parameters: {
          reportParameter: params
        }
      }
    end

    def path
      ['rest_v2', 'reportExecutions'].join '/'
    end
  end
end
