class CreateGroupmessages < ActiveRecord::Migration[5.1]
  def change
    create_table :groupmessages do |t|
      t.string :title 
      t.text :content, null: false
      t.datetime :meeting, null: false
      t.datetime :created
      t.integer   :user_id
      t.timestamps
    end
  end
end
