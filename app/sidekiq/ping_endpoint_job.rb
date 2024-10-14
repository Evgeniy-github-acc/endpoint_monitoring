class PingEndpointJob
  include Sidekiq::Job

  def perform(endpoint_id)
    endpoint = Endpoint.find_by_id(endpoint_id)
    if endpoint.present?
      Endpoints::StatusService.new.call(endpoint)
      Endpoints::HistoryService.new.call(endpoint)
      PingEndpointJob.perform_in(endpoint.period.seconds, endpoint.id)
    end
  end
end
