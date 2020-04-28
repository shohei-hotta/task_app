class AddDeadlineToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :datetime, default: "2030-04-26 23:59:59", null: false
  end
end
