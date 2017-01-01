class EulerPrimeJob
  attr_reader :length, :location, :result, :key

  def initialize(location, length)
    @euler = EulerCalc.new
    @pc = PrimeChecker.new

    @key = { :length => length, :location => location }
    @length = Integer(length) rescue nil
    @location = Integer(location) rescue nil
    @completed = false

    @result = {
      :key => key,
      :location => location,
      :length => length
    }

    validate
  end

  def execute
    return nil unless valid?

    current_position = 0
    primes_found = 0
    candidate = -1

    loop do
      candidate = @euler.substring(current_position, @length)
      primes_found += 1 if @pc.check(candidate)

      break if primes_found == @location

      current_position += 1
    end

    result[:position] = current_position
    result[:prime] = candidate

    @completed = true
  end

  def valid?
    @valid
  end

  def completed?
    @completed
  end

  private

  def validate
    @valid = !@location.nil? && !@length.nil?
  end
end
