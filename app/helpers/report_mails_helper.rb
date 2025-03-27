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
