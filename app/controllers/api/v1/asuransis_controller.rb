# app/controllers/api/v1/asuransis_controller.rb
module Api
  module V1
  class AsuransisController < ApplicationController
    before_action :authenticate_user!, only: %i[create update destroy]
    before_action :set_asuransi, only: %i[show update destroy]
    before_action :authorize_user!, only: %i[update destroy]

    # GET /api/v1/asuransis
    def index
      @asuransis = current_user.asuransis
      render json: @asuransis
    end

    # GET /api/v1/asuransis/:id
    def show
      render json: @asuransi
    end

    # POST /api/v1/asuransis
    def create
      @asuransi = current_user.asuransis.new(asuransi_params)
      if @asuransi.save
        render json: @asuransi, status: :created
      else
        render json: @asuransi.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/asuransis/:id
    def update
      if @asuransi.update(asuransi_params)
        render json: @asuransi
      else
        render json: @asuransi.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/asuransis/:id
    def destroy
      @asuransi.destroy
      head :no_content
    end

    private

    def set_asuransi
      @asuransi = asuransi.find(params[:id])
      render json: { error: 'asuransi not found' }, status: :not_found if @asuransi.nil?
    end

    def authorize_user!
      render json: { error: 'Not authorized' }, status: :forbidden unless @asuransi.user == current_user
    end

    def asuransi_params
      params.require(:asuransi).permit(:status, :active_date, :expire_date, :customer_id, :insurance_product_id)
    end
  end
  end
end
