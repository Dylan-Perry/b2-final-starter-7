require 'rails_helper'

describe Coupon do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :coupon_code }
    it { should validate_uniqueness_of(:coupon_code).scoped_to(:merchant_id) }
    it { should validate_presence_of :discount_amount }
    it { should validate_presence_of :discount_type }
    it { should validate_presence_of :status }
    it { should validate_presence_of :merchant_id }
  end

  describe "enums" do
    it { should define_enum_for(:discount_type).with_values([:dollars, :percent]) }
    it { should define_enum_for(:status).with_values([:active, :inactive]) }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should belong_to(:invoice).optional }
  end

  describe "defaults" do
    it "should default status to active (enum 0)" do
      coupon = create(:coupon)

      expect(coupon.status).to eq "active"
    end
  end

  it "won't create a coupon if merchant already has a coupon with same coupon code" do
    merchant1 = Merchant.create!(name: "Hair Care")
    merchant2 = Merchant.create!(name: "Donkus Goods")
    coupon = create(:coupon, coupon_code: "BOGO14", merchant_id: merchant1.id)

    expect{ Coupon.create!(name: "Coupon", coupon_code: "BOGO14", discount_amount: 5, discount_type: 1, merchant_id: merchant1.id) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Coupon code has already been taken")
    expect{ create(:coupon, coupon_code: "BOGO14", merchant_id: merchant2.id) }.to_not raise_error
  end
end