class Endpoints::HistoryService

  HISTORY_STORE_DAYS = 7.days.ago.to_date

  def call(endpoint)
    return unless endpoint.status.present?

    today = Date.current
    history_day = endpoint.history_days.find_or_initialize_by(date: today)

    if history_day.persisted?
      update_history_day(history_day, endpoint)
    else
      create_history_day(history_day, endpoint)
    end

    delete_old_history_days(endpoint)
  end

  private

  # Метод для обновления существующей записи
  def update_history_day(history_day, endpoint)
    if history_day.total_response_time.present?
      history_day.total_response_time += endpoint.status.response_time
    end
    history_day.request_count += 1
    if history_day.average_response_time.present?
      history_day.average_response_time = history_day.total_response_time / history_day.request_count
    end
    history_day.failed_requests_count += failed_requests_count(endpoint)
    history_day.status = set_status(history_day, endpoint)

    history_day.save!
  end

  # Метод для создания новой записи
  def create_history_day(history_day, endpoint)
    history_day.total_response_time = endpoint.status.response_time
    history_day.average_response_time = endpoint.status.response_time
    history_day.date = Date.today
    history_day.failed_requests_count = failed_requests_count(endpoint)
    history_day.request_count = 1
    history_day.status = endpoint.status.status
    history_day.endpoint = endpoint

    history_day.save!
  end

  # Метод для удаления записей старше HISTORY_STORE_DAYS
  def delete_old_history_days(endpoint)
    endpoint.history_days.where("date <= ?", HISTORY_STORE_DAYS).destroy_all
  end

  def set_status(history_day, endpoint)
    return :incident if history_day.status == "incident" || endpoint.status.status == "incident"
    return :degraded if history_day.status == "degraded" || endpoint.status.status == "degraded"
    :operational
  end

  def failed_requests_count(endpoint)
    return 0 if endpoint.status.status == "operational"
    1
  end
end
