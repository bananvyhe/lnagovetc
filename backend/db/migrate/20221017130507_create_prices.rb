class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices do |t|
      t.string :name
      t.integer :cost
      t.string :duration

      t.timestamps
    end
  end
end
