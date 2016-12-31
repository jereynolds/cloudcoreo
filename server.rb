require './boot'

class Server < Sinatra::Base
  THREAD_POOL_SIZE = 1

  configure :production, :development, :test do
    enable :logging

    set :root, File.join(File.dirname(__FILE__), "lib")
    set :views, File.join(root, "views")
  end

  @@worker_pool = JobWorkerPool.start(THREAD_POOL_SIZE)

  get '/' do
    erb :home
  end

  post '/calculate' do
    if create_job(params[:location], params[:length])
      @jobs = @@worker_pool.job_list
      @results = @@worker_pool.results_hash

      erb :results
    else
      erb :invalid
    end
  end

  post '/csv' do
  end

  get '/status' do
    @jobs = @@worker_pool.job_list
    @results = @@worker_pool.results_hash

    erb :results
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
end
