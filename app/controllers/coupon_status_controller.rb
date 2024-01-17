class CouponStatusController < ApplicationController
  def update
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
    
    if params[:status] == "inactive"
      if @coupon.pending_invoices?
        flash.notice = "Error: Can't deactivate coupon with pending invoices."
        determine_redirect     
      else
        @coupon.update(coupon_status_params)
        flash.notice = "Coupon '#{@coupon.name}' deactivated!"
        determine_redirect
      end
    elsif params[:status] == "active"
      if @merchant.five_or_more_activated_coupons?
        flash.notice = "Error: Merchant already has 5 active coupons."
        determine_redirect     
      else
        @coupon.update(coupon_status_params)
        flash.notice = "Coupon '#{@coupon.name}' activated!"
        determine_redirect
      end
    end
  end

  private
  def coupon_status_params
    params.permit(:status)
  end

  def determine_redirect
    if params[:source] == "index"
      redirect_to merchant_coupons_path
    else
      redirect_to merchant_coupon_path
    end
  end
end
