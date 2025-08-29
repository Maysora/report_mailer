class CreateReportMailMilestones < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mail_milestones do |t|
      t.references :report_mail_project, null: false, foreign_key: true
      t.string :name
      t.string :category, limit: 10
      t.integer :priority, null: false, default: 0
      t.timestamps
    end
  end
end
