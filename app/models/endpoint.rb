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
class Endpoint < ApplicationRecord

  has_one :status, class_name: "EndpointStatus", dependent: :destroy
  has_many :history_days, class_name: "HistoryDay", dependent: :destroy
  validates :name, presence: true
  validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :period, presence: true, numericality: { greater_than: 0 }
  validates :max_response_time, presence: true, numericality: { greater_than: 0 }

  after_update_commit -> { broadcast_replace_to "endpoints" }
  after_create_commit -> { broadcast_prepend_to "endpoints" }
  after_destroy_commit -> { broadcast_remove_to "endpoints" }
end
