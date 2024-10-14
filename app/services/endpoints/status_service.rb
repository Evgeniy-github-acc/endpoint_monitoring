require "net/http"

class Endpoints::StatusService
  def call(endpoint)
    uri = URI.parse(endpoint.url)

    start_time = Time.now
    begin
      response = Net::HTTP.get_response(uri)
    rescue SocketError, Net::OpenTimeout, Net::ReadTimeout => e
      update_endpoint_status(:incident, nil, endpoint)
      return
    end

    end_time = Time.now
    response_time = (end_time - start_time) * 1000 # время ответа в миллисекундах
    status = response_status(response, response_time, endpoint)

    update_endpoint_status(status, response_time, endpoint)
  end

  private

  def response_status(response, response_time, endpoint)
    if response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
      if response_time < endpoint.max_response_time
        :operational
      else
        :degraded
      end
    else
      :incident
    end
  end

  def update_endpoint_status(status, response_time, endpoint)
    if endpoint.status.present?
      endpoint.status.update!(status:, response_time:)
    else
      EndpointStatus.create!(endpoint_id: endpoint.id, status:, response_time:)
    end
  end
end
