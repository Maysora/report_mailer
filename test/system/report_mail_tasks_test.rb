require "application_system_test_case"

class ReportMailTasksTest < ApplicationSystemTestCase
  setup do
    @report_mail_task = report_mail_tasks(:one)
  end

  test "visiting the index" do
    visit report_mail_tasks_url
    assert_selector "h1", text: "Report mail tasks"
  end

  test "should create report mail task" do
    visit report_mail_tasks_url
    click_on "New report mail task"

    fill_in "Deploy status", with: @report_mail_task.deploy_status
    fill_in "Description", with: @report_mail_task.description
    fill_in "Issue number", with: @report_mail_task.issue_number
    fill_in "Notes", with: @report_mail_task.notes
    fill_in "Progress status", with: @report_mail_task.progress_status
    click_on "Create Report mail task"

    assert_text "Report mail task was successfully created"
    click_on "Back"
  end

  test "should update Report mail task" do
    visit report_mail_task_url(@report_mail_task)
    click_on "Edit this report mail task", match: :first

    fill_in "Deploy status", with: @report_mail_task.deploy_status
    fill_in "Description", with: @report_mail_task.description
    fill_in "Issue number", with: @report_mail_task.issue_number
    fill_in "Notes", with: @report_mail_task.notes
    fill_in "Progress status", with: @report_mail_task.progress_status
    click_on "Update Report mail task"

    assert_text "Report mail task was successfully updated"
    click_on "Back"
  end

  test "should destroy Report mail task" do
    visit report_mail_task_url(@report_mail_task)
    click_on "Destroy this report mail task", match: :first

    assert_text "Report mail task was successfully destroyed"
  end
end
