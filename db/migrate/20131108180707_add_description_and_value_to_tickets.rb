class AddDescriptionAndValueToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :description, :string
    add_column :tickets, :value, :integer
  end
end
