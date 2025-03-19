class CreateReportMails < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mails do |t|
      t.date :date
      t.string :to, null: false
      t.string :subject
      t.string :template
      t.string :status, null: false, default: 'draft'

      t.timestamps
    end
  end
end
