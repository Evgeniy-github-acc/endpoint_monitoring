class CreateHistoryDays < ActiveRecord::Migration[7.2]
  def change
    create_table :history_days do |t|
      t.references :endpoint, null: false, foreign_key: true
      t.date :date
      t.integer :average_response_time
      t.integer :total_response_time
      t.string :status
      t.integer :failed_requests_count
      t.integer :request_count

      t.timestamps
    end
  end
end
