class RemoveTicketIdFromETicketIdFromTransactions < ActiveRecord::Migration
  def up
    remove_column :transactions, :ticket_id
  end

  def down
    add_column :transactions, :ticket_id, :string
  end
end
