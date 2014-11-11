class AddTitleAndBodyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :title, :string
    add_column :events, :body, :text
  end
end
