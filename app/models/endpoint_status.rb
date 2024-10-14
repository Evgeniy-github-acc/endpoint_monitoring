# == Schema Information
#
# Table name: endpoint_statuses
#
#  id            :bigint           not null, primary key
#  response_time :integer
#  status        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  endpoint_id   :bigint           not null
#
# Indexes
#
#  index_endpoint_statuses_on_endpoint_id  (endpoint_id)
#
# Foreign Keys
#
#  fk_rails_...  (endpoint_id => endpoints.id)
#
class EndpointStatus < ApplicationRecord
  belongs_to :endpoint, touch: true
end
