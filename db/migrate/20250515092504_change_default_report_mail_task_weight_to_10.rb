class ChangeDefaultReportMailTaskWeightTo10 < ActiveRecord::Migration[7.0]
  def change
    change_column_default :report_mail_tasks, :weight, from: 1, to: 10
  end
end
