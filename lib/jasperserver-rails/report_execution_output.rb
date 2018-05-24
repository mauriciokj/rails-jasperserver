module JasperserverRails
  class ReportExecutionOutput < Base
    attr_accessor :request_id, :output_id

    def perform
      create_temp_file
      temp_file_path
    end

    private

    def create_temp_file
      FileUtils.mkdir_p(temp_path)
      temp_file = File.new(temp_file_path, 'wb')
      temp_file.write(generate_report.body)
      temp_file.close
    end

    def generate_report
      begin
        RestClient.get(url, { cookies: cookie, accept: :json })
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end

    def path
      ['rest_v2', 'reportExecutions', request_id, 'exports', output_id, 'outputResource'].join '/'
    end

    def temp_path
      "#{Rails.root}/tmp/jasper/#{request_id}"
    end

    def temp_file_path
      "#{temp_path}/#{output_id}"
    end
  end
end
