class Server < Sinatra::Base
  THREAD_POOL_SIZE = 1

  configure :production, :development, :test do
    enable :logging

    @@worker_pool = JobWorkerPool.start(THREAD_POOL_SIZE)
  end

  get '/' do
    erb :home
  end

  post '/calculate' do
    if create_job(params[:location], params[:length])
      erb :results
    else
      erb :invalid
    end
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
