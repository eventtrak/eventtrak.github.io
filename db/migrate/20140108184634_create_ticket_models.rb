class CreateTicketModels < ActiveRecord::Migration
  def change
    create_table :ticket_models do |t|
      t.string :description
      t.integer :value

      t.timestamps
    end
  end
end
