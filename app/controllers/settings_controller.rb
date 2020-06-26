class SettingsController < ApplicationController
    before_action :set_setting, only: [:show, :edit, :update, :destroy]
  
    def index
      @settings = Setting.all
    end
  
    def show
    end
  
    def new
      @setting = Setting.new
    end
  
    def edit
    end

    def create
      @setting = Setting.new(setting_params)
  
      respond_to do |format|
        if @setting.save
          format.html { redirect_to @setting, notice: 'Setting was successfully created.' }
          format.json { render :show, status: :created, location: @setting }
        else
          format.html { render :new }
          format.json { render json: @setting.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def update
      respond_to do |format|
        if @setting.update(setting_params)
          format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
          format.json { render :show, status: :ok, location: @setting }
        else
          format.html { render :edit }
          format.json { render json: @setting.errors, status: :unprocessable_entity }
        end
      end
    end
  

    def destroy
      @setting.destroy
      respond_to do |format|
        format.html { redirect_to settings_url, notice: 'Setting was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    private
      def set_setting
        @setting = Setting.find(params[:id])
      end
  
      def setting_params
        params.require(:setting).permit(:shop_id, :email_body_for_winner, :email_body_for_participant, :email_body_for_registration, :email_body_for_customer_registration_verification, :purchase_window)
      end
  end
  