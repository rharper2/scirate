class AddLastTimeScited < ActiveRecord::Migration[5.1]
  def change
   add_column :papers, :last_time_scited, :datetime
  end
end
