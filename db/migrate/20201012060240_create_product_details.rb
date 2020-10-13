class CreateProductDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :product_details do |t|
      t.string :name
      t.string :material_code
      t.string :product_category_code
      t.boolean :status

      t.timestamps
    end
    add_index :product_details, :material_code
  end
end
