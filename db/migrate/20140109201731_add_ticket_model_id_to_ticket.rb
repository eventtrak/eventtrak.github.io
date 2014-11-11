class AddTicketModelIdToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :ticket_model_id, :integer
  end
end
