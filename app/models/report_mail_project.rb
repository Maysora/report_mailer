class ReportMailProject < ApplicationRecord
  belongs_to :report_mail, inverse_of: :projects
  has_many :tasks, -> { order(:id) }, class_name: 'ReportMailTask', dependent: :destroy, inverse_of: :project
  has_many :active_tasks, -> { order(:id).active }, class_name: 'ReportMailTask', inverse_of: :project

  validates :name, presence: true

  serialize :server_urls

  scope :active, -> {
    q = distinct.left_joins(:active_tasks)
    q.where("#{table_name}.features_ready LIKE ?", '%Draft%').or(q.merge(ReportMailTask.active))
  }

  def self.duplicates!(new_report_mail)
    transaction do
      all.each do |project|
        project.duplicate!(new_report_mail)
      end
    end
  end

  def duplicate!(new_report_mail = nil)
    new_project = ReportMailProject.new(self.attributes.except(*%w[id report_mail_id created_at updated_at]))
    new_project.report_mail = new_report_mail || report_mail
    new_project.save!
    if new_project.report_mail != report_mail
      tasks.duplicates!(new_project)
    else
      tasks.duplicates!(new_project, exclude_done: false)
    end
    new_project
  end

  def long_name
    [name.presence, arr_to.first.presence].compact.join(' - ')
  end

  def server_urls=(value)
    if value.is_a?(String)
      value = value.split("\n").map { |str| str.downcase.split('|') }.to_h
    end
    super(value)
  end

  def string_server_urls
    return nil if server_urls.blank?
    server_urls.to_a.map { |arr| arr.join('|') }.join("\n")
  end

  def server_url_for(name)
    return nil if server_urls.blank?
    server_urls[name.to_s.downcase]
  end

  def active?(include_draft_features: true)
    (include_draft_features && features_ready.include?('Draft')) || active_tasks.present?
  end

  def arr_to
    to&.split(';')&.map(&:strip) || []
  end

  def total_tasks_weight
    active_tasks.sum(&:weight)
  end

  def total_tasks_weight_percentage
    active_tasks.map(&:weight_percentage).compact.sum
  end
end
