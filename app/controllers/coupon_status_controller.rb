class CouponStatusController < ApplicationController
  def update
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
    
    if params[:status] == "inactive"
      if @coupon.pending_invoices?
        flash.notice = "Error: Can't deactivate coupon with pending invoices."
        redirect_to merchant_coupon_path
      else
        @coupon.update(coupon_status_params)
        flash.notice = "Coupon '#{@coupon.name}' deactivated."
        if params[:source] == "index"
          redirect_to merchant_coupons_path
        else
          redirect_to merchant_coupon_path
        end
      end
    elsif params[:status] == "active"
      if @merchant.five_or_more_activated_coupons?
        flash.notice = "Error: Merchant already has 5 active coupons."
        redirect_to merchant_coupon_path
      else
        @coupon.update(coupon_status_params)
        flash.notice = "Coupon '#{@coupon.name}' activated!"
        if params[:source] == "index"
          redirect_to merchant_coupons_path
        else
          redirect_to merchant_coupon_path
        end
      end
    end
  end

  private
  def coupon_status_params
    params.permit(:status)
  end
end
