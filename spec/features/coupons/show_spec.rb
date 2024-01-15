require "rails_helper"
require 'helper_methods'

describe "merchant coupons show page (User Story 3)" do
  # As a merchant 
  # When I visit a merchant's coupon show page 
  # I see that coupon's name and code 
  # And I see the percent/dollar off value
  # As well as its status (active or inactive)
  # And I see a count of how many times that coupon has been used.

  # (Note: "use" of a coupon should be limited to successful transactions.)

  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon1 = create(:coupon, merchant_id: @merchant1.id)
    @coupon2 = create(:coupon, merchant_id: @merchant1.id)
    @coupon3 = create(:coupon, merchant_id: @merchant1.id)
  end

  it "can see all the coupon's attributes including name, coupon code, discount amount + type, and status" do
    visit merchant_coupon_path(@merchant1, @coupon1)

    expect(page).to have_content(@coupon1.name)
    expect(page).to have_content(@coupon1.coupon_code)
    expect(page).to have_content("Discount: #{@coupon1.discount_amount} #{@coupon1.discount_type} off")
    expect(page).to have_content(@coupon1.status)
    expect(page).to have_no_content(@coupon2.name)

    visit merchant_coupon_path(@merchant1, @coupon2)

    expect(page).to have_content(@coupon2.name)
    expect(page).to have_content(@coupon2.coupon_code)
    expect(page).to have_content("Discount: #{@coupon2.discount_amount} #{@coupon2.discount_type} off")
    expect(page).to have_content(@coupon2.status)
    expect(page).to have_no_content(@coupon3.name)
  end

  it "shows how many times the coupon has been used" do
    load_test_data_us_3
    
    visit merchant_coupon_path(@merchant1, @coupon1)

    expect(page).to have_content("Times Used: #{@coupon1.times_used}")
    expect(page).to have_no_content("Times Used: #{@coupon2.times_used}")

    visit merchant_coupon_path(@merchant1, @coupon2)

    expect(page).to have_content("Times Used: #{@coupon2.times_used}")
    expect(page).to have_no_content("Times Used: #{@coupon3.times_used}")

    visit merchant_coupon_path(@merchant2, @coupon3)

    expect(page).to have_content("Times Used: #{@coupon3.times_used}")
    expect(page).to have_no_content("Times Used: #{@coupon2.times_used}")
  end
end
