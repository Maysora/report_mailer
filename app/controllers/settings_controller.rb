class SettingsController < ApplicationController
  before_action :set_setting, only: %i[ show edit update destroy ]

  # GET /settings
  def index
    @settings = Setting.all
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  def create
    @setting = Setting.new(new_setting_params)

    if @setting.save
      redirect_to settings_url, notice: "Setting was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /settings/1
  def update
    if @setting.update(setting_params)
      redirect_to settings_url, notice: "Setting was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /settings/1
  def destroy
    @setting.destroy
    redirect_to settings_url, notice: "Setting was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    def new_setting_params
      params.fetch(:setting, {}).permit(:name, :value)
    end

    def setting_params
      params.fetch(:setting, {}).permit(:value)
    end
end
