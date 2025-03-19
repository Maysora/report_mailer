class ReportMailsController < ApplicationController
  before_action :set_report_mail, only: %i[ show edit update destroy send_email duplicate ]

  # GET /report_mails
  def index
    @report_mails = ReportMail.order(status: :asc, date: :desc).limit(50).all
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
      params.require(:report_mail).permit(:date, :to, :cc, :subject, :template, :signature)
    end
end
