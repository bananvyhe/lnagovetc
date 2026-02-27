class Telchange < ActiveRecord::Migration[6.1]
  def change
  	remove_column :contacts, :tel
  	add_column :contacts, :tel, :string
  end
end
