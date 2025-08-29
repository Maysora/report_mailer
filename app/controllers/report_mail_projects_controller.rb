class ReportMailProjectsController < ApplicationController
  before_action :set_report_mail
  before_action :set_report_mail_project, only: %i[ show edit update destroy duplicate ]

  # GET /report_mail_projects
  def index
    redirect_to @report_mail, status: :moved_permanently
  end

  # GET /report_mail_projects/1
  def show
    @tasks = @report_mail_project.tasks.reorder('report_mail_milestones.priority': :desc, id: :asc).includes(:milestone)
  end

  # GET /report_mail_projects/new
  def new
    @report_mail_project = @report_mail.projects.new
  end

  # GET /report_mail_projects/1/edit
  def edit
  end

  # POST /report_mail_projects
  def create
    @report_mail_project = @report_mail.projects.new(report_mail_project_params)

    if @report_mail_project.save
      redirect_to [@report_mail, @report_mail_project], notice: "Report mail project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /report_mail_projects/1
  def update
    if @report_mail_project.update(report_mail_project_params)
      redirect_to [@report_mail, @report_mail_project], notice: "Report mail project was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /report_mail_projects/1
  def destroy
    @report_mail_project.destroy
    redirect_to @report_mail, notice: "Report mail project was successfully destroyed.", status: :see_other
  end

  def duplicate
    new_report_mail_project = @report_mail_project.duplicate!
    redirect_to [@report_mail, new_report_mail_project], notice: "Report mail project was successfully copied.", status: :see_other
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: [@report_mail, @report_mail_project], alert: helpers.safe_join(e.record.errors.full_messages, helpers.tag.br), status: :see_other
  end

  private
    def set_report_mail
      @report_mail = ReportMail.find(params[:report_mail_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_report_mail_project
      @report_mail_project = @report_mail.projects.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_mail_project_params
      params.require(:report_mail_project).permit(:name, :features_ready_title, :features_ready, :to, :server_urls)
    end
end
