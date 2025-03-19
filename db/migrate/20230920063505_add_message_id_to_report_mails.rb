class AddMessageIdToReportMails < ActiveRecord::Migration[7.0]
  def change
    add_column :report_mails, :message_id, :string
  end
end
