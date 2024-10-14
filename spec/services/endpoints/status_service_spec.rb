# spec/services/endpoints/status_service_spec.rb

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Endpoints::StatusService do
  let(:endpoint) { create(:endpoint, url: 'http://example.com', max_response_time: 500) }
  let(:status_service) { described_class.new }

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe '#call' do
    context 'when the request is successful and fast' do
      it 'updates the endpoint status to :operational' do
        stub_request(:get, endpoint.url).to_return(status: 200, body: 'OK')

        expect { status_service.call(endpoint) }.to change { EndpointStatus.count }.by(1) # Проверка на создание статуса

        status = endpoint.reload.status # Загружаем связанный статус через reload
        expect(status.status).to eq('operational')
        expect(status.response_time).to be < endpoint.max_response_time
      end
    end

    context 'when the request is successful but slow' do
      it 'updates the endpoint status to :degraded' do
        stub_request(:get, endpoint.url).to_return(status: 200, body: 'OK')

        # Время ответа должно превышать 500 мс
        slow_response_time_in_seconds = (endpoint.max_response_time + 100) / 1000.0 # Перевод в секунды

        # Мокируем время для имитации задержки
        allow(Time).to receive(:now).and_return(Time.now, Time.now + slow_response_time_in_seconds)

        status_service.call(endpoint)

        status = endpoint.reload.status
        expect(status.status).to eq('degraded')
        expect(status.response_time).to be >= endpoint.max_response_time
      end
    end

    context 'when the request fails with a non-200 status' do
      it 'updates the endpoint status to :incident' do
        stub_request(:get, endpoint.url).to_return(status: 500)

        expect { status_service.call(endpoint) }.to change { EndpointStatus.count }.by(1)

        status = endpoint.reload.status
        expect(status.status).to eq('incident')
      end
    end

    context 'when a network error occurs' do
      it 'updates the endpoint status to :incident' do
        stub_request(:get, endpoint.url).to_raise(SocketError)

        expect { status_service.call(endpoint) }.to change { EndpointStatus.count }.by(1)

        status = endpoint.reload.status
        expect(status.status).to eq('incident')
      end
    end

    context 'when a timeout occurs' do
      it 'updates the endpoint status to :incident' do
        # Мокируем таймаут
        stub_request(:get, endpoint.url).to_timeout

        expect { status_service.call(endpoint) }.to change { EndpointStatus.count }.by(1)

        status = endpoint.reload.status
        expect(status.status).to eq('incident')
      end
    end
  end
end
