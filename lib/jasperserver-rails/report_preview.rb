module JasperserverRails
  class ReportPreview < Base
    attr_accessor :params

    def perform
      { 'url' => url }
    end

    protected

    def auth_params
      {
        'j_username' => config[:username],
        'j_password' => config[:password]
      }
    end

    def decorate
      'no'
    end

    def default_request_params
      {
        '_flowId' => flow_id,
        'ParentFolderUri' => parent_folder_uri,
        'reportUnit' => report,
        'standAlone' => stand_alone,
        'decorate' => decorate
      }
    end

    def flow_id
      'viewReportFlow'
    end

    def parent_folder_uri
      report.split('/').tap(&:pop).join('/')
    end

    def path
      "flow.html?#{request_params.to_query}"
    end

    def stand_alone
      true
    end

    def request_params
      @request_params = default_request_params
      @request_params.merge!(auth_params)
      @request_params.merge(params)
    end

    def url
      URI.join(config[:endpoint], path).to_s
    end
  end
end
