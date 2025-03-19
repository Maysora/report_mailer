require "application_system_test_case"

class ReportMailsTest < ApplicationSystemTestCase
  setup do
    @report_mail = report_mails(:one)
  end

  test "visiting the index" do
    visit report_mails_url
    assert_selector "h1", text: "Report mails"
  end

  test "should create report mail" do
    visit report_mails_url
    click_on "New report mail"

    fill_in "Subject", with: @report_mail.subject
    fill_in "Template", with: @report_mail.template
    fill_in "To", with: @report_mail.to
    click_on "Create Report mail"

    assert_text "Report mail was successfully created"
    click_on "Back"
  end

  test "should update Report mail" do
    visit report_mail_url(@report_mail)
    click_on "Edit this report mail", match: :first

    fill_in "Subject", with: @report_mail.subject
    fill_in "Template", with: @report_mail.template
    fill_in "To", with: @report_mail.to
    click_on "Update Report mail"

    assert_text "Report mail was successfully updated"
    click_on "Back"
  end

  test "should destroy Report mail" do
    visit report_mail_url(@report_mail)
    click_on "Destroy this report mail", match: :first

    assert_text "Report mail was successfully destroyed"
  end
end
