class CreateEducations < ActiveRecord::Migration[6.1]
  def change
    create_table :educations do |t|
      t.string :desc
      t.boolean :main

      t.timestamps
    end
  end
end
