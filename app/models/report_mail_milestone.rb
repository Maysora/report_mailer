class ReportMailMilestone < ApplicationRecord
  belongs_to :project, class_name: 'ReportMailProject', foreign_key: 'report_mail_project_id', inverse_of: :milestones
  has_many :tasks, class_name: 'ReportMailTask', dependent: :destroy, inverse_of: :project

  enum :category, bugfix: 'bugfix', feature: 'feature', research: 'research', refactor: 'refactor', other: 'other'

  validates :name, presence: true, uniqueness: { scope: [:report_mail_project_id] }
  validates :priority, presence: true

  def self.duplicates!(new_project)
    transaction do
      self.all.each do |milestone|
        milestone.duplicate!(new_project)
      end
    end
  end

  def duplicate!(new_project)
    new_task = ReportMailMilestone.new(self.attributes.except(*%w[id report_mail_project_id created_at updated_at]))
    new_task.project = new_project
    new_task.save!
  end
end
