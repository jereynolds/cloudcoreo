require 'set'
require 'thread'

class PrimeChecker
  @@primes = SortedSet.new([2, 3])

  @@next_to_check = @@primes.max + 2
  @@next_lock = Mutex.new

  def primes
    @@primes
  end

  # Check if a number is in the prime list. If the list is not high enough, extend it.
  # Return a boolean indicating whether the number is prime
  def check(number)
    generate number if number >= @@next_to_check

    @@primes.include? number
  end

private

  # Generate primes below an upper bound and append them to the list of primes,
  # starting after the highest checked number
  def generate(upper_bound)
    current = 0

    loop do
      @@next_lock.synchronize do
        current = @@next_to_check
        @@next_to_check += 2

        if prime? current
          @@primes.add current
        end
      end

      break if current >= upper_bound
    end
  end

  # Check the primeness of a number by checking its divisibility against the
  #   existing list of primes. Only need to check primes below the number's square root
  #   since anything larger would have another prime factor which was already checked
  def prime?(number)
    is_prime = true

    @@primes.each do |p|
      break if p > Math.sqrt(number).ceil

      if number % p == 0
        is_prime = false
        break
      end
    end

    is_prime
  end
end
