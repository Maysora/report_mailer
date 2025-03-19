# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview
  def send_report(report_mail = params[:id] || ReportMail.last)
    report_mail = ReportMail.find(report_mail) unless report_mail.is_a?(ReportMail)
    ReportMailer.send_report(report_mail)
  end
end
