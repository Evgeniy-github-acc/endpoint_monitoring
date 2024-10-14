# Очистим существующие данные перед созданием новых
Endpoint.destroy_all

# Создаем тестовые эндпоинты
endpoints = [
  {
    name: "Google",
    url: "https://www.google.com",
    max_response_time: 200, # 50 миллисекунд
    period: 5               # Опрос каждые 5 секунд
  },
  {
    name: "GitHub",
    url: "https://www.github.com",
    max_response_time: 1000, # 1 секунда
    period: 10               # Опрос каждые 10 секунд
  },
  {
    name: "Heroku",
    url: "https://www.heroku.com",
    max_response_time: 2000, # 2 секунды
    period: 15               # Опрос каждые 15 секунд
  },
  {
    name: "Non-Existent Site",
    url: "https://www.nonexistentsite12345.com",
    max_response_time: 500,  # 500 миллисекунд
    period: 5                # Опрос каждые 5 секунд
  }
]

# Создаем эндпоинты в базе данных
endpoints.each do |endpoint_data|
  endpoint = Endpoint.create!(endpoint_data)
  response_time = rand(50..endpoint.max_response_time) # Случайное время отклика

  # Генерируем записи EndpointStatus и HistoryDay

  6.downto(1) do |i|
    date = i.days.ago.to_date
    request_count = 24*60/endpoint.period

    status = %w[operational degraded incident].sample
    failed_requests_count = status == 'operational' ? 0 : rand(1..10)

    # Создаем запись в HistoryDay для данного дня
    HistoryDay.create!(
      endpoint: endpoint,
      date: date,
      average_response_time: response_time,
      request_count:,
      failed_requests_count:,
      status:
    )
  end

  PingEndpointJob.perform_async(endpoint.id)
end

puts "Seed data created!"
