class ChangeTasksDescriptionLimit200 < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :description, :string, limit: 200
  end
  def down
    change_column :tasks, :description, :string
  end
end
