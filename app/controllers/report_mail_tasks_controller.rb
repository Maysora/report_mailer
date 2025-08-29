class ReportMailTasksController < ApplicationController
  before_action :set_project
  before_action :set_report_mail_task, only: %i[ show edit update destroy ]

  # GET /report_mail_tasks
  def index
    @report_mail_tasks = @project.tasks.all
  end

  # GET /report_mail_tasks/1
  def show
  end

  # GET /report_mail_tasks/new
  def new
    @report_mail_task = @project.tasks.new(milestone: @project.default_milestone)
  end

  # GET /report_mail_tasks/1/edit
  def edit
  end

  # POST /report_mail_tasks
  def create
    @report_mail_task = @project.tasks.new(report_mail_task_params)

    if @report_mail_task.save
      redirect_to [@project.report_mail, @project, anchor: helpers.dom_id(@report_mail_task)], notice: "Report mail task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /report_mail_tasks/1
  def update
    if @report_mail_task.update(report_mail_task_params)
      redirect_to [@project.report_mail, @project, anchor: helpers.dom_id(@report_mail_task)], notice: "Report mail task was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /report_mail_tasks/1
  def destroy
    @report_mail_task.destroy
    redirect_to [@project.report_mail, @project], notice: "Report mail task was successfully destroyed.", status: :see_other
  end

  private
    def set_project
      @project = ReportMailProject.find(params[:report_mail_project_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_report_mail_task
      @report_mail_task = @project.tasks.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_mail_task_params
      params.require(:report_mail_task).permit(:report_mail_milestone_id, :issue_number, :category, :description, :weight, :progress_status, :deploy_status, :notes)
    end
end
