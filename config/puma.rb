# frozen_string_literal: true

puma_workers = ENV['SHAKURO_PUMA_WORKERS']
puma_workers = 4 if puma_workers.blank?
workers puma_workers

puma_threads_min = ENV['SHAKURO_PUMA_THREADS_MIN']
puma_threads_min = 0 if puma_threads_min.blank?
puma_threads_max = ENV['SHAKURO_PUMA_THREADS_MAX']
puma_threads_max = 8 if puma_threads_max.blank?
threads puma_threads_min, puma_threads_max

preload_app!
