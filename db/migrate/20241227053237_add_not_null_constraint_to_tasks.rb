class AddNotNullConstraintToTasks < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tasks, :deadline_on, false
    change_column_null :tasks, :priority, false
    change_column_null :tasks, :status, false
  end
end
