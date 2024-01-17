# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task["csv_load:all"].invoke

Coupon.create!(name: "5 Dollars Off", coupon_code: "5doff", discount_amount: 5, discount_type: 0, status: 1, merchant_id: 1)
Coupon.create!(name: "10 Percent Off", coupon_code: "10percent", discount_amount: 10, discount_type: 1, status: 1, merchant_id: 26)

Coupon.find(1).invoices << Invoice.find(29)