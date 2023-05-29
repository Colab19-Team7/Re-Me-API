class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :title
      t.string :description
      t.string :item_image
      t.string :item_link
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
