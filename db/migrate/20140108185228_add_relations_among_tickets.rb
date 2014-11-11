class AddRelationsAmongTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :event_id, :integer
    add_column :ticket_models, :event_id, :integer
  end
end
