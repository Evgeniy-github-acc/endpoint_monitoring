# == Schema Information
#
# Table name: endpoints
#
#  id                :bigint           not null, primary key
#  max_response_time :integer
#  name              :string
#  period            :integer
#  url               :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:status).class_name('EndpointStatus').dependent(:destroy) }
    it { is_expected.to have_many(:history_days).class_name('HistoryDay').dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to allow_value('http://example.com', 'https://example.com').for(:url) }
    it { is_expected.not_to allow_value('ftp://example.com', 'example.com').for(:url) }

    it { is_expected.to validate_presence_of(:period) }
    it { is_expected.to validate_numericality_of(:period).is_greater_than(0) }

    it { is_expected.to validate_presence_of(:max_response_time) }
    it { is_expected.to validate_numericality_of(:max_response_time).is_greater_than(0) }
  end

  describe 'callbacks' do
    let(:endpoint) { build :endpoint }

    it 'calls schedule_ping_job after create' do
      expect(endpoint).to receive(:schedule_ping_job)
      endpoint.save
    end

    it 'broadcasts replace on update' do
      endpoint.save
      expect { endpoint.update(name: 'New Name') }.to have_broadcasted_to('endpoints')
    end

    it 'broadcasts prepend on create' do
      expect { endpoint.save }.to have_broadcasted_to('endpoints')
    end

    it 'broadcasts remove on destroy' do
      endpoint.save
      expect { endpoint.destroy }.to have_broadcasted_to('endpoints')
    end
  end
end
