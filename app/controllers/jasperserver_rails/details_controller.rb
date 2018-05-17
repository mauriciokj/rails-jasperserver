require_dependency 'jasperserver_rails/application_controller'

module JasperserverRails
  class DetailsController < ApplicationController
    def show
      if params[:id] == "gerar"
        report_execution = ReportExecution.new(report: "/reports/interactive/relatorio_dispensacao_municipe", format: 'html', params: {"data_inicio" => "2018-01-01", "data_fim" => "2018-04-02", "hidden_title" => false})
        redirect_to detail_path(report_execution.perform["requestId"])
      else
        details = ReportExecutionDetails.new(request_id: params[:id])
        render json: details.perform
      end
    end
  end
end
