class AddPostidToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :post_id, :string
    add_column :posts, :integer, :string
  end
end
