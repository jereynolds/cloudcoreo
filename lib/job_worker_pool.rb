require 'thread'
require 'set'

class JobWorkerPool
  attr_reader :worker_count,
              :job_queue,
              :job_list,
              :job_list_lock,
              :results_lock,
              :results_hash

  def self.start(*args)
    new(*args).tap(&:start)
  end

  def initialize(worker_count)
    @worker_count = worker_count
    @job_queue = Queue.new
    @job_list = Set.new
    @job_list_lock = Mutex.new
    @results_hash = {}
    @results_lock = Mutex.new
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

    job_list_lock.synchronize do
      job_list.add(job.key)
    end

    job
  end

  private

  def thread_entry
    loop do
      perform(job_queue.deq)
    end
  end

  def perform(job)
    unless job.completed?
      job.execute

      results_lock.synchronize do
        results_hash[job.key] = job.result
      end

      job_list_lock.synchronize do
        job_list.delete(job.key)
      end
    end
  end
end
