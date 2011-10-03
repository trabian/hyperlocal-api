module.exports =

  preferred:
    accounts:
      list: '/accounts'
      single: '/accounts/{{id}}'
    externalAccounts:
      list: '/accounts/external_accounts'
    payees:
      list: '/accounts/payees'
    otherMemberAccounts:
      list: '/accounts/member_accounts'
    transfers:
      all: '/transfers'
      forAccount: '/accounts/{{account_id}}/transfers'
      create: '/transfers'
    transactions:
      list: '/accounts/{{account_id}}/transactions'
    estatements:
      list: '/documents/estatements'
    institutions:
      list: '/transfers/institutions?q={{query}}'

  actual:
    accounts:
      list: '/AccountDetails/accounts'
      single: '/AccountDetails/accounts/{{id}}'
    externalAccounts:
      list: '/transfers/externalaccounts'
      create: '/transfers/externalaccount'
    payees:
      list: '/billpay/payee/list'
      create: '/billpay/payee'
    otherMemberAccounts:
      list: '/transfers/bookmark/list'
    transfers:
      all: '/transfers/list'
      forAccount: '/transfers/list?account_id={{account_id}}'
      create: '/transfers/transfer'
    transactions:
      list: '/TransactionHistory/{{account_id}}'
    estatements:
      list: '/estatements/statement/list'
    institutions:
      list: '/transfers/institutions?q={{query}}'
    memberDetails:
      detail: '/MemberDetail'
      update: '/MemberDetail'
      updateAccountSort: '/AccountDetails/customsort'
    stopPayments:
      create: '/AccountDetails/accounts/{{account_id}}/stop_payments'
