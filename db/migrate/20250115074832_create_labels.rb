class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels do |t|
      t.string :name, null: false
      t.integer :user_id

      t.timestamps
    end
    add_foreign_key :labels, :users, column: :user_id
  end
end
