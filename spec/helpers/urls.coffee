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

  actual:
    accounts:
      list: '/AccountDetails/accounts'
      single: '/AccountDetails/accounts/{{id}}'
    externalAccounts:
      list: '/transfers/externalaccounts'
    payees:
      list: '/billpay/payee/list'
    otherMemberAccounts:
      list: '/transfers/bookmark/list'
