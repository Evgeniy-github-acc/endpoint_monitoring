class CreateEndpoints < ActiveRecord::Migration[7.2]
  def change
    create_table :endpoints do |t|
      t.string :name
      t.string :url
      t.integer :max_response_time
      t.integer :period

      t.timestamps
    end
  end
end
