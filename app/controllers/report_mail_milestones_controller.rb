class ReportMailMilestonesController < ApplicationController
  before_action :set_project
  before_action :set_report_mail_milestone, only: %i[ show edit update destroy ]

  # GET /report_mail_milestones
  def index
    @report_mail_milestones = @project.milestones.all
  end

  # GET /report_mail_milestones/1
  def show
  end

  # GET /report_mail_milestones/new
  def new
    @report_mail_milestone = @project.milestones.new
  end

  # GET /report_mail_milestones/1/edit
  def edit
  end

  # POST /report_mail_milestones
  def create
    @report_mail_milestone = @project.milestones.new(report_mail_milestone_params)

    if @report_mail_milestone.save
      redirect_to action: 'index', notice: "Report mail milestone was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /report_mail_milestones/1
  def update
    if @report_mail_milestone.update(report_mail_milestone_params)
      redirect_to action: 'index', notice: "Report mail milestone was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /report_mail_milestones/1
  def destroy
    @report_mail_milestone.destroy
    redirect_to action: 'index', notice: "Report mail milestone was successfully destroyed.", status: :see_other
  end

  private
    def set_project
      @project = ReportMailProject.find(params[:report_mail_project_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_report_mail_milestone
      @report_mail_milestone = @project.milestones.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_mail_milestone_params
      params.require(:report_mail_milestone).permit(:name, :category, :priority)
    end
end
