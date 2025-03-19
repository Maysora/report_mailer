class AllowNullToOnReportMails < ActiveRecord::Migration[7.0]
  def change
    change_column_null :report_mails, :to, true
  end
end
