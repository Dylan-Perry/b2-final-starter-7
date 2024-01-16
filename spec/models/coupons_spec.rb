require 'rails_helper'
require 'helper_methods'

describe Coupon do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :coupon_code }
    it { should validate_uniqueness_of :coupon_code }
    it { should validate_presence_of :discount_amount }
    it { should validate_presence_of :discount_type }
    it { should validate_presence_of :status }
    it { should validate_presence_of :merchant_id }
  end
  
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoices }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
  end
  
  describe "enums" do
    it { should define_enum_for(:discount_type).with_values([:dollars, :percent]) }
    it { should define_enum_for(:status).with_values([:active, :inactive]) }
  end

  describe "defaults" do
    it "should default status to inactive (enum 1)" do
      coupon = create(:coupon)

      expect(coupon.status).to eq "inactive"
    end
  end

  it "won't create a coupon if merchant already has a coupon with same coupon code" do
    merchant1 = Merchant.create!(name: "Hair Care")
    merchant2 = Merchant.create!(name: "Donkus Goods")
    coupon = create(:coupon, coupon_code: "BOGO14", merchant_id: merchant1.id)

    expect{ Coupon.create!(name: "Coupon", coupon_code: "BOGO14", discount_amount: 5, discount_type: 1, merchant_id: merchant1.id) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Coupon code has already been taken")
    expect{ Coupon.create!(name: "Coupon", coupon_code: "BOGO14", discount_amount: 5, discount_type: 1, merchant_id: merchant2.id) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Coupon code has already been taken")
  end

  describe "instance methods" do
    it "times_used" do
      load_test_data_us_3

      expect(@coupon1.times_used).to eq 4
      expect(@coupon2.times_used).to eq 1
      expect(@coupon3.times_used).to eq 0
    end

    it "pending_invoices?" do
      load_test_data_us_4

      expect(@coupon1.pending_invoices?).to eq false
      expect(@coupon2.pending_invoices?).to eq true
    end
  end
end