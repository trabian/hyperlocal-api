# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Member.all.each do |m|
#   m.delete
# end
# 
# Member.create(:first_name => "Jonathan", :last_name => "Dean", :middle_name => "Matthew")
# Member.create(:first_name => "Samuel", :last_name => "Carpenter", :middle_name => "Lewis")
# Member.create(:first_name => "David", :last_name => "Radcliffe", :middle_name => "W")

# User.all.each {|u| u.delete }
#   
# User.create(:email => "david@trabian.com", :password => "password", :member_id => Member.last.id)
# User.create(:email => "matt@trabian.com", :password => "password", :member_id => Member.first.id)
# 

Ticket.all.each {|a| a.delete }

Ticket.create(
  :title => "Lost debit card",
  :ticket_type => "lost_debit_card",
  :account_id => 1234,
  :state => "open",
  :assigned_user_id => User.first.id,
  :tags_raw => "debit_card card_services",
  :member_id => Member.first.id
)

Ticket.create(
  :title => "Notify beneficiaries of deceased account",
  :ticket_type => "beneficiary_notification",
  :account_id => 1234,
  :state => "solved",
  :assigned_user_id => User.last.id,
  :tags_raw => "deceased_account notification",
  :member_id => Member.last.id
)