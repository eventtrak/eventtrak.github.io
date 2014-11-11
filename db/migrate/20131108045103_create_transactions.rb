class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :ticket_id
      t.boolean :is_paid

      t.timestamps
    end
  end
end
