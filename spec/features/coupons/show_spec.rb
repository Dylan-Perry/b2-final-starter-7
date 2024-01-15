require "rails_helper"
require 'helper_methods'

describe "merchant coupons show page (User Story 3 and 4)" do
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
    expect(page).to have_content(@coupon1.status.capitalize)
    expect(page).to have_no_content(@coupon2.name)

    visit merchant_coupon_path(@merchant1, @coupon2)

    expect(page).to have_content(@coupon2.name)
    expect(page).to have_content(@coupon2.coupon_code)
    expect(page).to have_content("Discount: #{@coupon2.discount_amount} #{@coupon2.discount_type} off")
    expect(page).to have_content(@coupon2.status.capitalize)
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

  it "can make a button to disable items" do
    # As a merchant 
    # When I visit one of my active coupon's show pages
    # I see a button to deactivate that coupon
    # When I click that button
    # I'm taken back to the coupon show page 
    # And I can see that its status is now listed as 'inactive'.

    # * Sad Paths to consider: 
    # 1. A coupon cannot be deactivated if there are any pending invoices with that coupon.

    visit merchant_coupon_path(@merchant1, @coupon1)
    
    click_button "Deactivate"
    
    coupon = Coupon.find(@coupon1.id)

    expect(current_path).to eq(merchant_coupon_path(@merchant1, @coupon1))
    expect(coupon.status).to eq("inactive")
    expect(page).to have_content("Coupon '#{@coupon1.name}' deactivated.")
  end

  it "won't deactivate a coupon if coupon has pending invoices" do
    load_test_data_us_4
    
    visit merchant_coupon_path(@merchant1, @coupon1)
    
    click_button "Deactivate"

    coupon = Coupon.find(@coupon1.id)
    expect(coupon.status).to eq("inactive")

    visit merchant_coupon_path(@merchant1, @coupon2)
    
    click_button "Deactivate"

    coupon = Coupon.find(@coupon2.id)
    expect(coupon.status).to eq("active")
    expect(page).to have_content("Error: Can't deactivate coupon with pending invoices.")
  end
end
