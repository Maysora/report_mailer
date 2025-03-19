class ReportMailTask < ApplicationRecord
  belongs_to :project, class_name: 'ReportMailProject', foreign_key: 'report_mail_project_id', inverse_of: :tasks

  validates :description, presence: true

  scope :done, -> { where('progress_status ILIKE ?', 'done') }
  scope :not_done, -> { where.not('progress_status ILIKE ?', 'done') }
  scope :active, -> { where.not(description: [nil, '', '-']) }

  def self.duplicates!(new_project, exclude_done: true, minimum: 1)
    transaction do
      tasks = exclude_done ? not_done : all
      tasks.each do |task|
        task.duplicate!(new_project)
      end
      (minimum - tasks.length).times do |_|
        create!(project: new_project, description: '-', progress_status: 'done', deploy_status: 'staging')
      end if all.exists?
    end
  end

  def duplicate!(new_project)
    new_task = ReportMailTask.new(self.attributes.except(*%w[id report_mail_project_id notes created_at updated_at]))
    new_task.project = new_project
    new_task.save!
  end

  def active?
    description.present? && description != '-'
  end

  def deploy_status_with_link
    return deploy_status if deploy_status.blank?

    deploy_status.split(',').map do |status|
      status.strip!
      url = project&.server_url_for(status)
      url ? "[#{status}](#{url})" : status
    end.join(', ')
  end
end
