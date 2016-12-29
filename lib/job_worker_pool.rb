require 'thread'

class JobWorkerPool
  attr_reader :worker_count, :job_queue, :results_lock, :results_hash

  def self.start(*args)
    new(*args).tap(&:start)
  end

  def initialize(worker_count)
    @worker_count = worker_count
    @job_queue = Queue.new
    @results_lock = Mutex.new
    @results_hash = {}
  end

  def start
    worker_count.times do
      Thread.new do
        begin
          thread_entry
        rescue StandardError => ex
          puts "Background thread faild with #{ex.inspect}"
        end
      end
    end
  end

  def add_job(job)
    job_queue.enq(job)
    job
  end

  private

  def thread_entry
    loop do
      perform(job_queue.deq)
    end
  end

  def perform(job)
    job.calculate!

    results_lock.synchronize do
      results_hash[job.key] = job.result
    end
  end
end
