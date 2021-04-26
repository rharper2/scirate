class AddLikeTypeToScite < ActiveRecord::Migration[5.1]
  def change
	add_column :scites, :like_type, :integer, default: 2
  end
end
