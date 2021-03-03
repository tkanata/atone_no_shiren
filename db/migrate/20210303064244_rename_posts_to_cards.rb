class RenamePostsToCards < ActiveRecord::Migration[6.1]
  def change
    rename_table :posts, :cards
  end
end
