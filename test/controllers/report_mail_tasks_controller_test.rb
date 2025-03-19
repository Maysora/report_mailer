require "test_helper"

class ReportMailTasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report_mail_task = report_mail_tasks(:one)
  end

  test "should get index" do
    get report_mail_tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_report_mail_task_url
    assert_response :success
  end

  test "should create report_mail_task" do
    assert_difference("ReportMailTask.count") do
      post report_mail_tasks_url, params: { report_mail_task: { deploy_status: @report_mail_task.deploy_status, description: @report_mail_task.description, issue_number: @report_mail_task.issue_number, notes: @report_mail_task.notes, progress_status: @report_mail_task.progress_status } }
    end

    assert_redirected_to report_mail_task_url(ReportMailTask.last)
  end

  test "should show report_mail_task" do
    get report_mail_task_url(@report_mail_task)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_mail_task_url(@report_mail_task)
    assert_response :success
  end

  test "should update report_mail_task" do
    patch report_mail_task_url(@report_mail_task), params: { report_mail_task: { deploy_status: @report_mail_task.deploy_status, description: @report_mail_task.description, issue_number: @report_mail_task.issue_number, notes: @report_mail_task.notes, progress_status: @report_mail_task.progress_status } }
    assert_redirected_to report_mail_task_url(@report_mail_task)
  end

  test "should destroy report_mail_task" do
    assert_difference("ReportMailTask.count", -1) do
      delete report_mail_task_url(@report_mail_task)
    end

    assert_redirected_to report_mail_tasks_url
  end
end
