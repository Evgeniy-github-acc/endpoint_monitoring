class CreateEndpoints < ActiveRecord::Migration[7.2]
  def change
    create_table :endpoints do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :max_response_time, null: false
      t.integer :period, null: false

      t.timestamps
    end
  end
end
