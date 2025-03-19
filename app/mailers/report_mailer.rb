class ReportMailer < ApplicationMailer
  layout false
  helper :application
  def send_report(report_mail)
    @report = report_mail
    @projects = @report.projects.active.includes(:active_tasks)
    @tasks = @projects.map(&:active_tasks).flatten(1).sort_by(&:updated_at)
    delivery_options = {
      address: Setting['mail_address'],
      port: Setting['mail_port'],
      domain: Setting['mail_domain'],
      user_name: Setting['mail_username'],
      password: Setting['mail_password'],
      authentication: Setting['mail_authentication'],
    }
    message_ids = @report.previous_message_ids.first(5)
    arr_to = @report.arr_to + @projects.map(&:arr_to).flatten(1)
    mail(
      from: Setting['mail_username'],
      to: arr_to.uniq.sort.join(';'),
      cc: @report.cc,
      subject: @report.subject,
      template_name: @report.template,
      message_id: @report.message_id,
      in_reply_to: message_ids.first,
      references: message_ids.presence,
      delivery_method_options: delivery_options
    )
  end
end
