class AddIndexToTasksStatus < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :status
  end
end
# index(見出し)をつける
# rails g migration add_index_to_tasks_status→追記してrails db:migrate