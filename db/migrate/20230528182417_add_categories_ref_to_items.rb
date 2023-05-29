class AddCategoriesRefToItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :items, :category, null: true, foreign_key: true
  end
end
