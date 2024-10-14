# == Schema Information
#
# Table name: endpoints
#
#  id                :bigint           not null, primary key
#  max_response_time :integer          not null
#  name              :string           not null
#  period            :integer          not null
#  url               :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :endpoint do
    name { "Test Endpoint" }
    url { "http://example.com" }
    period { 60 }
    max_response_time { 1000 }
  end
end
