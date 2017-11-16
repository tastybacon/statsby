# Statsby

A lightweight statsd client built in Ruby. This is in early development and things are likely to change often.

## Usage
```ruby
client = Statsby::Client.new #defaults to sending metrics to localhost:8125
client.gauge('my_gauge', 5)

# Connect to a different host and port:
client = Statsby::Client.new(host: 'example.com', port 23456)
```

### Metric Types
```ruby
client = Statsby::Client.new

# Counters
client.counter('my_counter', 5)
# my_counter:5|c

# Gauges
client.gauge('my_gauge', 5)
# my_gauge:5|g

# Timings
client.timing('my_timing', 5)
# my_timing:5|ms

# Sets
client.set('my_set', 5)
# my_set:5|s
```

### Tags
```ruby
# You can tag a client, which tags all metrics sent by that client
client = Statsby::Client.new(tags: { 'client-tag' => 'test' })

client.gauge('my_gauge', 5)
# => 'my_gauge,client-tag=test:5|g'

# In addition, you can add tags to a any metric
client.gauge('my_gauge', 5, { 'metric-tag' => 'whoa' })
# => 'my_gauge,client-tag=test,metric-tag=whoa:5|g'
```

You can disable tags for a client by passing this flag:
```ruby
tagless_client = Statsby::Client.new(tags_enabled: false)

tagless_client.gauge('my_gauge', 5)
# => 'my_gauge:5|g'

# The client will also ignore tags passed directly to metrics/contexts
tagless_client.gauge('my_gauge', 5, { 'metric-tag' => 'whoa' })
# => 'my_gauge:5|g'
```

### Contexts
A thin layer over a client that facilitates tag organization.
```ruby
# You can tag a client, which tags all metrics sent by that client
client = Statsby::Client.new(tags: { 'client-tag' => 'test' })

context = client.subcontext('context-tag' => 'cool')
context.gauge('my_gauge', 5)
# => 'my_gauge,client-tag=test,context-tag=cool:5|g'
```

You can even create a context from another context!
```ruby
# You can tag a client, which tags all metrics sent by that client
client = Statsby::Client.new(tags: { 'client-tag' => 'test' })

context = client.subcontext('context-tag' => 'cool')
subcontext = context.subcontext('subcontext-tag' => 'awesome')
subcontext.gauge('my_gauge', 5)
# => 'my_gauge,client-tag=test,context-tag=cool,subcontext-tag=awesome:5|g'
```

### Tag Precedence
Tags closer to the client will be overridden by tags further away from the client.
```ruby
client = Statsby::Client.new(tags: { 'client-tag' => 'test' })

context = client.subcontext('context-tag' => 'cool')
subcontext = context.subcontext('context-tag' => 'awesome') # Overriding tag from parent context
subcontext.gauge('my_gauge', 5)
# => 'my_gauge,client-tag=test,context-tag=awesome:5|g'

# You can still use the parent context with its original tags
context.gauge('my_gauge', 5)
# => 'my_gauge,client-tag=test,context-tag=cool:5|g'

# Tags directly on metrics override everything
client.gauge('my_gauge', 5, 'client-tag' => 'overwridden')
# => my_gauge,client-tag=overwridden:5|g
```

## TODO

- Documentation (ha)
- Proper Logging
- Default tags (e.g. host, ip, etc.)
- Sampling
- Validation of metric names, tag keys and values, perhaps more.
