class CouponStatusController < ApplicationController
  def update
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.find(params[:id])
    
    if @coupon.pending_invoices?
      flash.notice = "Error: Can't deactivate coupon with pending invoices."
      redirect_to merchant_coupon_path
    else
      @coupon.update(coupon_status_params)
      if @coupon.status == "active"
        flash.notice = "Coupon '#{@coupon.name}' activated!"
      else
        flash.notice = "Coupon '#{@coupon.name}' deactivated."
      end
      redirect_to merchant_coupon_path
    end
  end

  private
  def coupon_status_params
    params.permit(:status)
  end
end
