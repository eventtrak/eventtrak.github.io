class AddAmountsToTicketModels < ActiveRecord::Migration
  def change
    add_column :ticket_models, :max_amount, :integer
  end
end
