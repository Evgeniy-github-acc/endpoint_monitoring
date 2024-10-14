# spec/services/endpoints/history_service_spec.rb

require 'rails_helper'

RSpec.describe Endpoints::HistoryService do
  let(:endpoint) { create(:endpoint) }
  let(:status) { create(:endpoint_status, endpoint: endpoint, status: 'operational', response_time: 200) }
  let(:history_service) { described_class.new }
  let(:today) { Date.current }

  before do
    endpoint.status = status
  end

  describe '#call' do
    context 'when the history record for today does not exist' do
      it 'creates a new history record for today' do
        expect { history_service.call(endpoint) }.to change { endpoint.history_days.count }.by(1)

        history_day = endpoint.history_days.last
        expect(history_day.date).to eq(today)
        expect(history_day.total_response_time).to eq(status.response_time)
        expect(history_day.average_response_time).to eq(status.response_time)
        expect(history_day.request_count).to eq(1)
        expect(history_day.failed_requests_count).to eq(0)
        expect(history_day.status).to eq('operational')
      end
    end

    context 'when the history record for today already exists' do
      let!(:existing_history_day) { create(:history_day, endpoint: endpoint, date: today, total_response_time: 100, request_count: 1) }

      it 'updates the existing history record' do
        expect { history_service.call(endpoint) }.not_to change { endpoint.history_days.count }

        existing_history_day.reload
        expect(existing_history_day.total_response_time).to eq(300) # 100 + 200 (новый response_time)
        expect(existing_history_day.average_response_time).to eq(150) # среднее 300/2
        expect(existing_history_day.request_count).to eq(2)
        expect(existing_history_day.failed_requests_count).to eq(0) # так как статус 'operational'
        expect(existing_history_day.status).to eq('operational')
      end
    end

    context 'when the endpoint status is incident' do
      let(:status) { create(:endpoint_status, endpoint: endpoint, status: 'incident', response_time: 300) }

      it 'increments failed_requests_count and updates the status to incident' do
        expect { history_service.call(endpoint) }.to change { endpoint.history_days.count }.by(1)

        history_day = endpoint.history_days.last
        expect(history_day.failed_requests_count).to eq(1)
        expect(history_day.status).to eq('incident')
      end
    end

    context 'when the endpoint status is degraded' do
      let(:status) { create(:endpoint_status, endpoint: endpoint, status: 'degraded', response_time: 300) }

      it 'updates the status to degraded' do
        expect { history_service.call(endpoint) }.to change { endpoint.history_days.count }.by(1)

        history_day = endpoint.history_days.last
        expect(history_day.failed_requests_count).to eq(1)
        expect(history_day.status).to eq('degraded')
      end
    end

    context 'when there are old history records' do
      let!(:old_history_day) { create(:history_day, endpoint: endpoint, date: 8.days.ago.to_date) }

      it 'deletes history records older than 7 days' do
        expect { history_service.call(endpoint) }.to change { endpoint.history_days.count }.by(0)

        expect(endpoint.history_days.exists?(old_history_day.id)).to be false
      end
    end

    context 'when the endpoint has no status' do
      before { endpoint.status = nil }

      it 'does not create or update any history records' do
        expect { history_service.call(endpoint) }.not_to change { endpoint.history_days.count }
      end
    end
  end
end
