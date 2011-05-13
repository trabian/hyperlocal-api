require.paths.unshift '.'

Faker = require './support/Faker'
async = require 'async'
_ = require 'underscore'

config =
  database: 'mongodb://localhost/hyperlocal_api'

require('app/models').load(config)

{ Account, Member } = config.models

membersToCreate = 5

timer = "create #{membersToCreate} members"

console.time timer

Member.remove {}, ->

  createMember = (callback) ->

    member = new Member
      first_name: Faker.Name.firstName()
      middle_name: Faker.Name.firstName()
      last_name: Faker.Name.lastName()
      phone: Faker.PhoneNumber.phoneNumber()
      address:
        street1: Faker.Address.streetAddress()
        street2: if (Math.random() < 0.3) then Faker.Address.secondaryAddress()
        city: Faker.Address.city()
        state: Faker.Address.usState(true)
        zip: Faker.Address.zipCode()

    member.save ->

      account = new Account
        number: 1
        member_id: member._id

      account.save callback

  async.parallel (createMember for num in [1..membersToCreate]), ->
    console.timeEnd timer
    config.mongoose.connection.close()
