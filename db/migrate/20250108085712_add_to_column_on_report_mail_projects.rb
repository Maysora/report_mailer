class AddToColumnOnReportMailProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :report_mail_projects, :to, :string 
  end
end
