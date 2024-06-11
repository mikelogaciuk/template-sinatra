#!/usr/bin/env puma
# frozen_string_literal: true
require_relative './config/config'

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum, this matches the default thread size of Active Record.
#
threads_min= ENV.fetch('PUMA_THREADS') { 4 }.to_i
threads_max = ENV.fetch('PUMA_THREADS') { 12 }.to_i
threads threads_min, threads_max

# Specifies the `port` that Puma will listen on to receive requests, default is 3000.
#
port ENV.fetch('PORT') { CONFIG['api']['port'] }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch('WORKERS') { 4 }.to_i

# Load metrics plugin
plugin 'metrics'

# Bind the metric server to "url". "tcp://" is the only accepted protocol.
#
# The default is "tcp://0.0.0.0:9393".
metrics_url 'tcp://0.0.0.0:9393'
