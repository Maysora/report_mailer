class AddReportMailMilestoneIdToReportMailTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :report_mail_tasks, :report_mail_milestone, null: true, foreign_key: true
  end
end
