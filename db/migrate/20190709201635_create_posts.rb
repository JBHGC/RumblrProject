class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :image_url
      t.string :user_name
      t.date :created_at
    end
  end
end
