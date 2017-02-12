require 'matrix'

class EulerCalc
  LOWER_BOUND = 1
  UPPER_BOUND = 2

  @@digits = []
  @@iteration = 1
  @@state = Matrix.I(2)
  @@state_lock = Mutex.new

  # Generate the next n digits of e
  def generate(n)
    start = digits.length

    while digits.length < start + n
      calc
    end
  end

  # Return the integer representation of a string of digits
  # location is 0-indexed
  def substring(first, length)
    number = 0
    last = first + length

    generate(last - digits.length) if (last > digits.length)

    digits[first...last].each do |digit|
      number *= 10
      number += Integer(digit)
    end

    number
  end

  def digits
    @@digits
  end

  private

  # Run one iteration of the spigot algorithm
  # This may not produce a digit (precision can increase without the lower and upper
  # bounds converging for the next digit)
  def calc
    @@state_lock.synchronize do
      @@state = @@state * transformation(@@iteration)

      lower = apply(LOWER_BOUND).floor
      upper = apply(UPPER_BOUND).floor

      collect(lower) if lower == upper

      @@iteration += 1
    end
  end

  # Store the digit, then apply a transformation to the state
  # to subtract the value and multiply by 10
  def collect(digit)
    transform = Matrix[ [10, -10 * digit],
                        [0, 1] ]

    digit += 1 if digits.empty? # Algorithm produces e-1 so add 1
    digits.push digit

    @@state = transform * @@state
  end

  # Gives the transformation matrix for the nth sub-function in the taylor series for e
  def transformation(n)
    Matrix[ [1, 1 + n],
            [0, 1 + n] ]
  end

  # Apply the mobius transformation to a value representing the tail of the
  # infinite series of transformations (ie a lower or upper bound for the tail)
  #
  # transform is a 2x2 matrix [a, b,
  #                            c, d]
  # value is a scalar
  def apply(value)
    t = @@state

    Float(t[0, 0] * value + t[0, 1]) / Float(t[1, 0] * value + t[1, 1])
  end
end
