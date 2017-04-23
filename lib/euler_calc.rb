class EulerCalc
  LOWER_BOUND = 1
  UPPER_BOUND = 2

  @@digits = []
  @@iteration = 1
  @@state = Matrix.I(2)
  @@state_lock = Mutex.new
  @@twos_removed = 0
  @@fives_removed = 0

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

  def e_string
    return "" unless digits.length > 0
    return digits.first.to_s unless digits.length > 1

    str = "#{digits.first}."

    digits[1..-1].each do |d|
      str += d.to_s
    end

    str
  end

  private

  # Run one iteration of the spigot algorithm
  # This may not produce a digit (precision can increase without
  # the lower and upper bounds converging for the next digit)
  def calc
    @@state_lock.synchronize do
      @@state = @@state * transformation(@@iteration)

      reduce_state if @@iteration % 10 == 0

      lower = apply(LOWER_BOUND).floor
      upper = apply(UPPER_BOUND).floor

      collect(lower) if lower == upper

      @@iteration += 1
    end
  end

  def reduce_state
    total_fives = Integer((@@iteration + 1) / 5)
    total_twos = Integer((@@iteration + 1) / 2)

    twos_to_remove = total_twos - @@twos_removed
    fives_to_remove = total_fives - @@fives_removed
    factor_to_remove = (2 ** twos_to_remove) * (5 ** fives_to_remove)

    @@twos_removed += twos_to_remove
    @@fives_removed += fives_to_remove

    @@state = @@state / Matrix.scalar(2, factor_to_remove)
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

    numerator = Float(t[0, 0] * value + t[0, 1])
    denominator = Float(t[1, 0] * value + t[1, 1])

    numerator / denominator
  end
end
