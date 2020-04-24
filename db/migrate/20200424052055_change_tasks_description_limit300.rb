class ChangeTasksDescriptionLimit300 < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :description, :text, limit: 300
  end
  def down
    change_column :tasks, :description, :text
  end
end
