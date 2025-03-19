require "test_helper"

class ReportMailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report_mail = report_mails(:one)
  end

  test "should get index" do
    get report_mails_url
    assert_response :success
  end

  test "should get new" do
    get new_report_mail_url
    assert_response :success
  end

  test "should create report_mail" do
    assert_difference("ReportMail.count") do
      post report_mails_url, params: { report_mail: { subject: @report_mail.subject, template: @report_mail.template, to: @report_mail.to } }
    end

    assert_redirected_to report_mail_url(ReportMail.last)
  end

  test "should show report_mail" do
    get report_mail_url(@report_mail)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_mail_url(@report_mail)
    assert_response :success
  end

  test "should update report_mail" do
    patch report_mail_url(@report_mail), params: { report_mail: { subject: @report_mail.subject, template: @report_mail.template, to: @report_mail.to } }
    assert_redirected_to report_mail_url(@report_mail)
  end

  test "should destroy report_mail" do
    assert_difference("ReportMail.count", -1) do
      delete report_mail_url(@report_mail)
    end

    assert_redirected_to report_mails_url
  end
end
