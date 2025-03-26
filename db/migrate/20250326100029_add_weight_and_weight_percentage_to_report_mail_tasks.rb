class AddWeightAndWeightPercentageToReportMailTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :report_mail_tasks, :weight, :integer, default: 1, null: false
    add_column :report_mail_tasks, :weight_percentage, :decimal, precision: 6, scale: 3
  end
end
