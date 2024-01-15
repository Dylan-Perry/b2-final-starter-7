class CouponsController < ApplicationController
  before_action :find_merchant, only: [:new, :create, :index]
  before_action :find_coupon_and_merchant, only: [:show]

  def index
    @coupons = @merchant.coupons
  end

  def show

  end

  def new

  end

  def create
    if @merchant.five_or_more_activated_coupons?
      flash.notice = "Error: Merchant already has 5 active coupons."
      redirect_to merchant_coupons_path(@merchant)
    else
      @coupon = Coupon.new(name: params[:name],
                           coupon_code: params[:coupon_code],
                           discount_amount: params[:discount_amount],
                           discount_type: params[:discount_type],
                           merchant: @merchant)

      if @coupon.valid?
        @coupon.save
        flash.notice = "Coupon created successfully!"
        redirect_to merchant_coupons_path(@merchant)
      else
        flash.notice = "Error: #{@coupon.errors.full_messages[0]}"
        # redirecting due to issues with turbolinks + render; would like to use turbolinks_render gem in the future
        redirect_to new_merchant_coupon_path(@merchant)
      end
    end
  end

  private

  def coupon_params
      params.require(:coupon).permit(:name, :coupon_code, :discount_amount, :discount_type, :merchant_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_coupon_and_merchant
    @coupon = Coupon.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end
end
