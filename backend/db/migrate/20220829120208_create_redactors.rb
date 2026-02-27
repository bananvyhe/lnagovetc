class CreateRedactors < ActiveRecord::Migration[6.1]
  def change
    create_table :redactors do |t|
      t.text :about
      t.text :consult
      t.string :zaprosi
      t.text :education
      t.text :karta

      t.timestamps
    end
  end
end
