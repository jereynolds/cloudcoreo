class EulerPrimeJob
  attr_reader :length, :location, :result, :key

  def initialize(location, length)
    @key = [location, length]

    @location = Integer(location) rescue nil
    @length = Integer(length) rescue nil

    @euler = EulerCalc.new
    @pc = PrimeChecker.new

    @result = { :prime => nil, :position => nil }
    @completed = false

    validate
  end

  def execute
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
