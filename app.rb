$LOAD_PATH.push File.expand_path("./lib")

# External libs
require 'sinatra'

# Application libs
require 'job_worker_pool'
require 'euler_prime_job'

require 'server'
