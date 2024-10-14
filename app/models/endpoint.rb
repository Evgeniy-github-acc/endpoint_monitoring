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
class Endpoint < ApplicationRecord
  has_one :status, class_name: "EndpointStatus", dependent: :destroy
  has_many :history_days, class_name: "HistoryDay", dependent: :destroy
  validates :name, presence: true
  validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :period, presence: true, numericality: { greater_than: 0 }
  validates :max_response_time, presence: true, numericality: { greater_than: 0 }

  after_create :schedule_ping_job

  after_update_commit -> { broadcast_replace_to "endpoints" }
  after_create_commit -> { broadcast_prepend_to "endpoints" }
  after_destroy_commit -> { broadcast_remove_to "endpoints" }

  private

  def schedule_ping_job
    PingEndpointJob.perform_async(self.id)
  end
end
