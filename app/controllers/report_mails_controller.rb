class ReportMailsController < ApplicationController
  before_action :set_report_mail, only: %i[ show edit update destroy send_email duplicate ]

  # GET /report_mails
  def index
    @report_mails = ReportMail.order(status: :asc, date: :desc)
    @report_mails =
      if params[:incomplete_tasks_data]
        @report_mails
          .with_incomplete_data
          .where(date: date_filter)
      else
        @report_mails.limit(50)
      end
  end

  # GET /report_mails/monthly_summary
  def monthly_summary
    @report_mail_tasks = ReportMailTask
      .with_complete_data
      .joins(project: :report_mail)
      .merge(
        ReportMail.where(date: date_filter)
      )
      .select("#{ReportMailTask.table_name}.*")
      .select("#{ReportMailProject.table_name}.name project_name")
      .select("#{ReportMail.table_name}.template template")
    total_weight_percentage = @report_mail_tasks.sum(&:weight_percentage)
    @summary_data = @report_mail_tasks
      .group_by(&:template)
      .transform_values do |tasks_by_template|
        tasks_by_template
          .group_by(&:project_name)
          .map do |project_name, tasks_by_project|
            tasks_by_project
              .group_by(&:category)
              .map do |category, tasks_by_category|
                weight_percentage = ((tasks_by_category.sum(&:weight_percentage) / total_weight_percentage) * 100).round(3)
                {
                  project_name: project_name,
                  category: category,
                  weight_percentage: weight_percentage,
                  weight_percentage_rounded: weight_percentage.round
                }
              end
        end.flatten(1)
      end
  end

  # GET /report_mails/1
  def show
  end

  # GET /report_mails/new
  def new
    @report_mail = ReportMail.new
  end

  # GET /report_mails/1/edit
  def edit
  end

  # POST /report_mails
  def create
    @report_mail = ReportMail.new(report_mail_params)

    if @report_mail.save
      redirect_to @report_mail, notice: "Report mail was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /report_mails/1
  def update
    if @report_mail.update(report_mail_params)
      redirect_to @report_mail, notice: "Report mail was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /report_mails/1
  def destroy
    @report_mail.destroy
    redirect_to report_mails_url, notice: "Report mail was successfully destroyed.", status: :see_other
  end

  def send_email
    if @report_mail.ready?
      @report_mail.send_email
      redirect_to @report_mail, notice: "Report mail was successfully sent.", status: :see_other
    elsif @report_mail.draft?
      @report_mail.ready!
      redirect_to @report_mail, notice: "Report mail ready to be sent.", status: :see_other
    elsif @report_mail.sent?
      @report_mail.draft!
      redirect_to @report_mail, notice: "Report mail back to draft.", status: :see_other
    end
  end

  def duplicate
    new_report_mail = @report_mail.duplicate!
    redirect_to new_report_mail, notice: "Report mail was successfully copied.", status: :see_other
  rescue ActiveRecord::RecordInvalid => e
    redirect_back fallback_location: @report_mail, alert: helpers.safe_join(e.record.errors.full_messages, helpers.tag.br), status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report_mail
      @report_mail = ReportMail.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_mail_params
      params.require(:report_mail).permit(:date, :to, :cc, :subject, :template, :signature, :status)
    end

    def date_filter
      @date_filter ||=
        begin
          start_date = params[:date].present? ? Time.zone.parse(params[:date]).to_date : Time.zone.today.prev_month.change(day: 26)
          (start_date..start_date.next_month.prev_day)
        end
    end
end
