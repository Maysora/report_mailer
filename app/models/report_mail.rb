class ReportMail < ApplicationRecord
  TEMPLATES = %i[wgs].freeze
  has_many :projects, -> { order(:name, :id) }, class_name: 'ReportMailProject', dependent: :destroy

  enum :status, draft: 'draft', ready: 'ready', sent: 'sent'

  before_validation :set_default_attributes
  before_save :set_status, unless: :status_changed?

  validates :date, presence: true
  validates :message_id, uniqueness: { allow_nil: true }

  def send_email
    return if !ready?
    ReportMailer.send_report(self).deliver_now
    sent!
  end

  def subject_date
    date.strftime('%b %Y')
  end

  def duplicate!
    transaction do
      new_mail = ReportMail.new(self.attributes.except(*%w[id date subject status message_id created_at updated_at]))
      new_mail.date = [Time.zone.today, 1.day.since(date)].max
      new_mail.subject =
        if new_mail.subject_date == subject_date
          subject
        else
          subject.sub(subject_date, new_mail.subject_date)
        end
      new_mail.save!
      projects.duplicates!(new_mail)
      new_mail
    end
  end

  def default_message_id
    @default_message_id ||= "ReportMail/#{Setting['mail_username'].parameterize}/#{projects.detect(&:name?)&.name&.parameterize || '-'}/#{date.strftime('%Y-%m')}"
  end

  def previous_report_mails
    @previous_report_mails ||= ReportMail
      .where(subject: subject, id: ...id)
      .sent
  end

  def previous_message_ids
    previous_report_mails.order(id: :desc).map do |report_mail|
      report_mail.message_id.presence || default_message_id
    end.uniq
  end

  def arr_to
    to&.split(';')&.map(&:strip) || []
  end

  private

  def set_default_attributes
    self.date ||= Time.zone.today
    self.subject = self.subject.presence || "<Project> Daily Report #{subject_date}"
    self.signature = self.signature.presence || Setting['mail_signature']
    self.message_id ||= "#{SecureRandom.uuid}.#{Time.zone.now.to_i}.#{Setting['mail_username'].presence || '@report-mail'}" unless sent?
  end

  def set_status
    self.status = 'draft'
  end
end
