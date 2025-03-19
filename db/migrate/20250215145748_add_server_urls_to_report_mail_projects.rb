class AddServerUrlsToReportMailProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :report_mail_projects, :server_urls, :text
  end
end
