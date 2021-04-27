class AddLatestCommentToPapers < ActiveRecord::Migration[5.1]
  def change
    add_column :papers, :latest_comment, :datetime
  end
end
