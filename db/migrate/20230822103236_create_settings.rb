class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :name, null: false, limit: 100
      t.string :value

      t.timestamps
    end
    add_index :settings, :name
  end
end
