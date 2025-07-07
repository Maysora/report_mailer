class ReportMailTask < ApplicationRecord
  belongs_to :project, class_name: 'ReportMailProject', foreign_key: 'report_mail_project_id', inverse_of: :tasks

  enum :category, bugfix: 'bugfix', feature: 'feature', research: 'research', refactor: 'refactor', other: 'other'

  validates :description, presence: true
  validates :weight, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000, allow_nil: false}
  validates :weight_percentage, numericality: { only_integer: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true}

  after_save :calculate_weight_percentage!, if: -> { (saved_change_to_id? || saved_change_to_weight?) && project&.report_mail }
  after_destroy :calculate_weight_percentage!

  scope :done, -> { where('progress_status ILIKE ?', 'done') }
  scope :not_done, -> { where.not('progress_status ILIKE ?', 'done') }
  scope :active, -> { where.not(description: [nil, '', '-']) }
  scope :with_complete_data, -> { where.not(weight_percentage: nil).where.not(category: nil) }
  scope :with_incomplete_data, -> { where(weight_percentage: nil).or(where(category: nil)) }

  # TODO: async job
  def self.duplicates!(new_project, exclude_done: true)
    transaction do
      tasks = exclude_done ? not_done : all
      tasks.each do |task|
        task.duplicate!(new_project)
      end
    end
  end

  def self.calculate_weight_percentage!(total:)
    transaction do
      all.each do |task|
        task.update! weight_percentage:
          if total.zero?
            0
          else
            ((task.weight.to_d / total) * 100).round(3)
          end
      end
    end
  end

  def calculate_weight_percentage!(total: nil)
    return unless project&.report_mail

    project.report_mail.reload.calculate_tasks_weight_percentage!
  end

  def duplicate!(new_project)
    new_task = ReportMailTask.new(self.attributes.except(*%w[id report_mail_project_id weight_percentage notes created_at updated_at]))
    new_task.project = new_project
    new_task.weight ||= 10
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
