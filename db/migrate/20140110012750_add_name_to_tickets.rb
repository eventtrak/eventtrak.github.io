class AddNameToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :name, :string
    add_column :ticket_models, :name, :string
  end
end
