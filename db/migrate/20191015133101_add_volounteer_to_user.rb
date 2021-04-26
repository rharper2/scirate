class AddVolounteerToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :volounteer_count, :integer, default: 0
    add_column :papers, :volounteer_id, :integer
  end
end
