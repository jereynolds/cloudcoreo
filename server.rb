require './boot'

class Server < Sinatra::Base
  THREAD_POOL_SIZE = 5

  configure :production, :development, :test do
    enable :logging

    set :root, File.dirname(__FILE__)
    set :views, File.join(root, "lib/views")
    set :public_folder, File.join(root, "public")
  end

  @@worker_pool = JobWorkerPool.start(THREAD_POOL_SIZE)

  get '/' do
    erb :home
  end

  get '/results' do
    erb :results
  end

  post '/calculate' do
    if create_job(params[:location], params[:length])
      erb :results
    else
      erb :invalid
    end
  end

  post '/csv' do
    success = true

    CSV.parse(params["csvfile"][:tempfile]) do |row|
      success = false unless create_job(row[0], row[1])
    end

    success ? erb(:results) : erb(:invalid)
  end

  get '/status.json' do
    content_type :json

    {
      jobs: jobs,
      results: results,
      max_prime: max_prime,
      e_string: e_string
    }.to_json
  end

  private

  def create_job(location, length)
    job = EulerPrimeJob.new(location, length)

    if job.valid?
      @@worker_pool.add_job job
    else
      nil
    end
  end

  def max_prime
    PrimeChecker.new.primes.max.to_s
  end

  def jobs
    @@worker_pool.job_list.to_a
  end

  def results
    @@worker_pool.results_hash
  end

  def e_string
    digits = EulerCalc.new.e_string
  end
end
