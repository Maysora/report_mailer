require "application_system_test_case"

class ReportMailProjectsTest < ApplicationSystemTestCase
  setup do
    @report_mail_project = report_mail_projects(:one)
  end

  test "visiting the index" do
    visit report_mail_projects_url
    assert_selector "h1", text: "Report mail projects"
  end

  test "should create report mail project" do
    visit report_mail_projects_url
    click_on "New report mail project"

    fill_in "Features ready", with: @report_mail_project.features_ready
    fill_in "Features ready title", with: @report_mail_project.features_ready_title
    fill_in "Name", with: @report_mail_project.name
    fill_in "Report mail", with: @report_mail_project.report_mail_id
    click_on "Create Report mail project"

    assert_text "Report mail project was successfully created"
    click_on "Back"
  end

  test "should update Report mail project" do
    visit report_mail_project_url(@report_mail_project)
    click_on "Edit this report mail project", match: :first

    fill_in "Features ready", with: @report_mail_project.features_ready
    fill_in "Features ready title", with: @report_mail_project.features_ready_title
    fill_in "Name", with: @report_mail_project.name
    fill_in "Report mail", with: @report_mail_project.report_mail_id
    click_on "Update Report mail project"

    assert_text "Report mail project was successfully updated"
    click_on "Back"
  end

  test "should destroy Report mail project" do
    visit report_mail_project_url(@report_mail_project)
    click_on "Destroy this report mail project", match: :first

    assert_text "Report mail project was successfully destroyed"
  end
end
