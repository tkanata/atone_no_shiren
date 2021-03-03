class RenamePostsToPokers < ActiveRecord::Migration[6.1]
  def change
    rename_table :posts, :pokers
  end
end
