async = require 'async'

memberSeed = require('app/seeds/member')
accountSeed = require('app/seeds/account')
externalAccountSeed = require('app/seeds/external_account')
documentSeed = require('app/seeds/document')
institutionSeed = require('app/seeds/institution')

module.exports = class Seeder

  constructor: (@options) ->

  seed: (callback) ->

    { Member, Account, Document, ExternalAccount, MemberAccount, PayeeAccount, Transaction, Transfer, TransferInstance } = @options.models

    dropCollection = (collection, callback) ->
      collection.remove {}, callback

    async.forEach [Member, Account, ExternalAccount, MemberAccount, PayeeAccount, Transaction, Transfer, TransferInstance, Document], dropCollection, (err) =>
      if err 
        console.log 
      else
        @createMembers callback

  seedInstitutions: (callback) ->

    { Institution } = @options.models

    Institution.remove {}, =>
      institutionSeed.createMultiple @options, callback

  createMembers: (callback) =>

    memberSeed.createMultiple
      startingId: 123001
      models: @options.models
      count: @options.count
      onCreate: @createMemberData
      callback: callback

  createAccounts: (member, callback) =>

    accountSeed.create
      member: member
      models: @options.models
      callback: callback

  createExternalAccounts: (member, callback) =>

    externalAccountSeed.createMultiple
      member: member
      models: @options.models
      callback: callback

  createDocuments: (member, callback) =>

    documentSeed.createMultiple
      member: member
      models: @options.models
      callback: callback
      monthsToCreate: 12

  createMemberData: (member, callback) =>

    memberDataCreators = for creator in [@createAccounts, @createExternalAccounts, @createDocuments]
      async.apply creator, member

    async.parallel memberDataCreators, callback
