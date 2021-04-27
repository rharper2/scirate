class AddScirateCitesToPaper < ActiveRecord::Migration[5.1]
  def change
    add_column :papers, :scirate_rates, :integer, default: 0
  end
end
