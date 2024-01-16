def load_test_data_us_3
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Donkus Goods")

    @coupon1 = create(:coupon, coupon_code: "BOGO14", merchant_id: @merchant1.id)
    @coupon2 = create(:coupon, coupon_code: "freb14", merchant_id: @merchant1.id) 
    @coupon3 = create(:coupon, coupon_code: "hehelol", merchant_id: @merchant2.id)

    @invoice1 = create(:invoice, coupon_id: @coupon1.id)
    @invoice2 = create(:invoice, coupon_id: @coupon1.id)
    @invoice3 = create(:invoice, coupon_id: @coupon2.id)
    @invoice4 = create(:invoice, coupon_id: @coupon2.id)
    @invoice5 = create(:invoice, coupon_id: @coupon3.id)

    @transaction1 = create(:transaction, invoice_id: @invoice1.id, result: 1)
    @transaction2 = create(:transaction, invoice_id: @invoice1.id, result: 1)
    @transaction3 = create(:transaction, invoice_id: @invoice1.id, result: 0) # Sad path: should not count, transaction status = 0
    @transaction4 = create(:transaction, invoice_id: @invoice2.id, result: 1)
    @transaction5 = create(:transaction, invoice_id: @invoice2.id, result: 1) 
    @transaction6 = create(:transaction, invoice_id: @invoice3.id, result: 0) # Sad path: should not count, transaction status = 0
    @transaction7 = create(:transaction, invoice_id: @invoice4.id, result: 1)
    @transaction8 = create(:transaction, invoice_id: @invoice5.id, result: 0) # Sad path: should not count, transaction status = 0

    expect(@coupon1.times_used).to eq 4
    expect(@coupon2.times_used).to eq 1
    expect(@coupon3.times_used).to eq 0
end

def load_test_data_us_4
    @merchant1 = Merchant.create!(name: "Hair Care")

    @coupon1 = create(:coupon, coupon_code: "BOGO14", merchant_id: @merchant1.id, status: 0)
    @coupon2 = create(:coupon, coupon_code: "flarpo", merchant_id: @merchant1.id, status: 0)

    @invoice1 = create(:invoice, coupon_id: @coupon1.id)
    @invoice2 = create(:invoice, coupon_id: @coupon1.id)
    @invoice3 = create(:invoice, coupon_id: @coupon2.id)
    @invoice4 = create(:invoice, coupon_id: @coupon2.id)

    @item = create(:item, merchant_id: @merchant1.id)

    @invoice_item1 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice1.id, status: 1)
    @invoice_item2 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice1.id, status: 1)
    @invoice_item3 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice2.id, status: 1)
    @invoice_item4 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice2.id, status: 1)
    @invoice_item5 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice3.id, status: 1)
    @invoice_item6 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice3.id, status: 1)
    @invoice_item7 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice4.id, status: 0) # Sad path: pending status prevents @coupon2 from deactivating
    @invoice_item8 = create(:invoice_item, item_id: @item.id, invoice_id: @invoice4.id, status: 1)
end