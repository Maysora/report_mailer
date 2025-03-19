require "test_helper"

class ReportMailProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report_mail_project = report_mail_projects(:one)
  end

  test "should get index" do
    get report_mail_projects_url
    assert_response :success
  end

  test "should get new" do
    get new_report_mail_project_url
    assert_response :success
  end

  test "should create report_mail_project" do
    assert_difference("ReportMailProject.count") do
      post report_mail_projects_url, params: { report_mail_project: { features_ready: @report_mail_project.features_ready, features_ready_title: @report_mail_project.features_ready_title, name: @report_mail_project.name, report_mail_id: @report_mail_project.report_mail_id } }
    end

    assert_redirected_to report_mail_project_url(ReportMailProject.last)
  end

  test "should show report_mail_project" do
    get report_mail_project_url(@report_mail_project)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_mail_project_url(@report_mail_project)
    assert_response :success
  end

  test "should update report_mail_project" do
    patch report_mail_project_url(@report_mail_project), params: { report_mail_project: { features_ready: @report_mail_project.features_ready, features_ready_title: @report_mail_project.features_ready_title, name: @report_mail_project.name, report_mail_id: @report_mail_project.report_mail_id } }
    assert_redirected_to report_mail_project_url(@report_mail_project)
  end

  test "should destroy report_mail_project" do
    assert_difference("ReportMailProject.count", -1) do
      delete report_mail_project_url(@report_mail_project)
    end

    assert_redirected_to report_mail_projects_url
  end
end
