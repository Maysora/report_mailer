class CreateReportMailProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mail_projects do |t|
      t.belongs_to :report_mail, null: false, foreign_key: true
      t.string :name, null: false
      t.string :features_ready_title
      t.text :features_ready

      t.timestamps
    end
  end
end
