module Hyperlocal

  class Timeline

    def self.fetch(options = {})

      start = options[:start] || 0
      count = options[:count] || 10
      list = options[:list] || 'events'

      events = $redis.lrange list, start, start + count - 1

      events.collect { |event| JSON.parse(event) }

    end

    def self.insert(event)
      $redis.lpush 'events', event.to_json
    end

  end

end
