class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.belongs_to :user, index: true

      t.integer :to_user
      t.integer :from_user
      t.boolean :read
      # t.integer :point_id
      t.text :body

      t.timestamps
    end
  end
end
