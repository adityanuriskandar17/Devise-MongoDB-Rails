# app/controllers/insurance_products_controller.rb

module Api
  module V1
  class InsuranceProductsController < ApplicationController
    before_action :authenticate_user!, only: %i[create update destroy]
    before_action :set_insurance_product, only: %i[show update destroy]
    before_action :authorize_user!, only: %i[update destroy]
      # GET /insurance_products
      def index
        @insurance_products = current_user.insurance_products
        render json: @insurance_products
      end
    
      # GET /insurance_products/:id
      def show
        render json: @insurance_product
      end
    
      # POST /insurance_products
      def create
        @insurance_product = current_user.insurance_products.new(insurance_product_params)
        if @insurance_product.save
          render json: @insurance_product, status: :created
        else
          render json: @insurance_product.errors, status: :unprocessable_entity
        end
      end
    
      # PATCH/PUT /insurance_products/:id
      def update
        if @insurance_product.update(insurance_product_params)
          render json: @insurance_product
        else
          render json: @insurance_product.errors, status: :unprocessable_entity
        end
      end
    
      # DELETE /insurance_products/:id
      def destroy
        @insurance_product.destroy
        head :no_content
      end
    
      private
  
      def set_insurance_product
        @insurance_product = InsuranceProduct.find(params[:id])
      end
    
      def authorize_user!
        render json: {error: 'Not authorized'}, status: :forbidden unless @insurance_product.user == current_user
      end
  
      def insurance_product_params
        params.require(:insurance_product).permit(:name)
      end
  end
  end  
end