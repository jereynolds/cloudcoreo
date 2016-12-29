class EulerPrimeJob
  attr_reader :length, :location, :result, :key

  def initialize(location, length)
    @key = [location, length]

    @location = Integer(location) rescue nil
    @length = Integer(length) rescue nil

    validate
  end

  def calculate!
    @result = key
  end

  def valid?
    @valid
  end

  private

  def validate
    @valid = !@location_int.nil? && !@length_int.nil?
  end
end
