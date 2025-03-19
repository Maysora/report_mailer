class CreateReportMailTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mail_tasks do |t|
      t.belongs_to :report_mail_project, null: false, foreign_key: true
      t.string :issue_number
      t.text :description, null: false
      t.string :progress_status
      t.string :deploy_status
      t.text :notes

      t.timestamps
    end
  end
end
