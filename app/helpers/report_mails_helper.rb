module ReportMailsHelper
  def date_css_class(report_mail)
    if report_mail.date == Time.zone.today
      'text-bg-success d-inline-block px-2 rounded'
    elsif !report_mail.sent?
      'text-bg-warning d-inline-block px-2 rounded'
    else
      nil
    end
  end

  def report_mail_buttons(report_mail)
    duplicate_button =
      if report_mail.date.today? && !report_mail.sent?
        nil
      elsif !report_mail.date.today? && report_mail.sent?
        button_to('Duplicate', [:duplicate, report_mail], method: :post, class: 'btn btn-success')
      else
        button_to('Duplicate', [:duplicate, report_mail], method: :post, data: { turbo_confirm: 'Duplicate?' }, class: 'btn btn-warning')
      end
    send_button =
      if report_mail.draft?
        button_to('Ready', [:send_email, report_mail], method: :post, class: 'btn btn-success')
      elsif report_mail.ready?
        button_to('Send this report mail', [:send_email, report_mail], method: :post, data: { turbo_confirm: 'Send this report mail?' }, class: 'btn btn-success')
      else
        button_to('Draft', [:send_email, report_mail], method: :post, data: { turbo_confirm: 'Set draft?' }, class: 'btn btn-warning')
      end
    safe_join([duplicate_button, send_button].compact, "\n")
  end

  def task_stats(project)
    project.active_tasks.group_by(&:category).map do |category, tasks_by_category|
      "#{category.presence || 'N/A'} [" + [
        number_with_delimiter(tasks_by_category.length),
        number_with_delimiter(tasks_by_category.sum(&:weight)),
        number_to_percentage(tasks_by_category.map(&:weight_percentage).compact.sum, strip_insignificant_zeros: true),
      ].join(', ') + "]"
    end.join(' | ')
  end
end
