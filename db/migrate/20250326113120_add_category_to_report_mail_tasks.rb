class AddCategoryToReportMailTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :report_mail_tasks, :category, :string, limit: 10
  end
end
