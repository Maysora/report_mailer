class AddCcAndSignatureToReportMails < ActiveRecord::Migration[7.0]
  def change
    add_column :report_mails, :cc, :string
    add_column :report_mails, :signature, :text
  end
end
