module Api
  module V1
  class CustomersController < ApplicationController
    before_action :authenticate_user!, only: %i[create update destroy]
    before_action :set_customer, only: %i[show update destroy]
    before_action :authorize_user!, only: %i[update destroy]

    # GET /api/v1/customers
    def index
      @customers = current_user.customers
      render json: @customers
    end

    # GET /api/v1/customers/:id
    def show
      render json: @customer
    end

    # POST /api/v1/customers
    def create
      @customer = current_user.customers.new(customer_params) 
      if @customer.save
        render json: @customer, status: :created
      else
        render json: @customer.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/customers/:id
    def update
      if @customer.update(customer_params)
        render json: @customer
      else
        render json: @customer.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/customers/:id
    def destroy
      @customer.destroy
      head :no_content
    end

    private

    def fetch_customer_from_cache(id)
      customer = $redis.get("customer:#{id}")
      if customer
        Rails.logger.info "Customer #{id} found in Redis cache"
        JSON.parse(customer)
      else
        customer = Customer.find(id)
        $redis.set("customer:#{id}", customer.to_json)
        Rails.logger.info "Customer #{id} not found in Redis cache. Queried from DB and cached."
        customer
      end
    end

    def set_customer
      @customer = Customer.find(params[:id])
    end

    def authorize_user!
      render json: { error: 'Not authorized' }, status: :forbidden unless @customer.user == current_user
    end

    def customer_params
      params.require(:customer).permit(:name, :dob, :address, :phone)
    end
  end
  end
end
