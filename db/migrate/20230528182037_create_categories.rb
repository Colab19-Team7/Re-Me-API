class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :category_image
      t.string :domain

      t.timestamps
    end
  end
end
