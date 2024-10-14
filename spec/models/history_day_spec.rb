# == Schema Information
#
# Table name: history_days
#
#  id                    :bigint           not null, primary key
#  average_response_time :integer
#  date                  :date
#  failed_requests_count :integer
#  request_count         :integer
#  status                :string
#  total_response_time   :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  endpoint_id           :bigint           not null
#
# Indexes
#
#  index_history_days_on_endpoint_id  (endpoint_id)
#
# Foreign Keys
#
#  fk_rails_...  (endpoint_id => endpoints.id)
#
require 'rails_helper'

RSpec.describe HistoryDay, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
