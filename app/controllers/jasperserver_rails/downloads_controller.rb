require_dependency 'jasperserver_rails/application_controller'

module JasperserverRails
  class DownloadsController < ApplicationController
    def show
      report_output = ReportExecutionOutput.new request_id: params[:detail_id], output_id: params[:id], login: current_login
      send_file report_output.perform, filename: params[:filename]
    end
  end
end
