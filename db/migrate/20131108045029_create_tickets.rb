class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :code
      t.integer :transaction_id

      t.timestamps
    end
  end
end
