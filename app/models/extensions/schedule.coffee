module.exports =

  lastOccurrence:
    type: Date
    get: (date) ->

      return date if date?

      if @state is 'single'
        @created_at
      else
        @start_at if @start_at <= new Date()

  nextOccurrence:
    type: Date
    get: (date) ->
      
      return date if date?

      if @state is 'scheduled'

        if @start_at > new Date()
          return @start_at
        else

          nextDate = new Date(@last_occurrence)

          frequencies =
            weekly: 
              label: 'Weekly'
              days: 7
            biweekly:
              label: 'Bi-Weekly'
              days: 14
            monthly:
              label: 'Monthly'
              months: 1
            quarterly:
              label: 'Quarterly'
              months: 3
            semiannually:
              label: 'Semi-Annually'
              months: 6
            annually:
              label: 'Annually'
              months: 12

          frequency = frequencies[@frequency]

          if frequency.days?
            nextDate.setDate nextDate.getDate() + frequency.days
          else if frequency.months?
            nextDate.setMonth nextDate.getMonth() + frequency.months

          nextDate

  state:
    type: String
    get: ->
      switch @type
        when 'recurring'
          now = Date.now()
          if @end_at >= now then "scheduled" else "expired"
        when 'later'
          if @start_at >= Date.now() then "scheduled" else "expired"
        else
          "single"
