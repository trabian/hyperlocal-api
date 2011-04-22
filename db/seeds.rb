# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# NOTE: This will currently clear some of the existing data!!!

Member.all.each {|a| a.delete }

Member.create(
  :first_name => "Jonathan",
  :last_name => "Dean",
  :middle_name => "Matthew",
  :street => "1234 Some Street",
  :city => "Fishers",
  :state => "IN",
  :zip => "46038",
  :phone => "555 123-4567"
)
Member.create(:first_name => "Samuel", :last_name => "Carpenter", :middle_name => "Lewis")
Member.create(
  :first_name => "David",
  :last_name => "Radcliffe",
  :middle_name => "W",
  :street => "870 Halyard Drive",
  :city => "Avon",
  :state => "IN",
  :zip => "46123",
  :phone => "123 456-7890"
)

# User.all.each {|u| u.delete }
#   
# User.create(:email => "david@trabian.com", :password => "password", :first_name => "David", :last_name => "Radcliffe")
# User.create(:email => "matt@trabian.com", :password => "password", :member_id => Member.first.id, :first_name => "Matt", :last_name => "Dean")
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


Comment.create(
  :ticket => Ticket.first,
  :user_id => User.first.id,
  :body => "This is the first comment!",
  :public => false
)

Comment.create(
  :ticket => Ticket.first,
  :user_id => User.first.id,
  :body => "This is the second comment!",
  :public => false
)

Comment.create(
  :ticket => Ticket.first,
  :user_id => User.first.id,
  :body => "Dear X, We ARE working on this. Chill yo.",
  :public => true
)
