class CreateEndpointStatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :endpoint_statuses do |t|
      t.references :endpoint, null: false, foreign_key: true
      t.string :status
      t.integer :response_time

      t.timestamps
    end
  end
end
