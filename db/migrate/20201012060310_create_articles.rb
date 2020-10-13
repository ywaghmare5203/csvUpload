class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.string :author
      t.text :title
      t.text :description
      t.text :url
      t.text :utlToImage
      t.datetime :published_at
      t.text :content

      t.timestamps
    end
  end
end
