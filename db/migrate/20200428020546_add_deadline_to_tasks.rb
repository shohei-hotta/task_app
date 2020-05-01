class AddDeadlineToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :datetime, default: "9998-12-31 23:59:59", null: false
  end
end
