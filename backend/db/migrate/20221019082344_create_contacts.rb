class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.integer :tel
      t.string :desc
      t.string :position

      t.timestamps
    end
  end
end
