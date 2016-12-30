require 'thread'

class EulerCalc
  LOWER_BOUND = 1
  UPPER_BOUND = 2
  IDENTITY_MATRIX = [1, 0,
                     0, 1]

  @@digits = []
  @@iteration = 1
  @@state = IDENTITY_MATRIX
  @@state_lock = Mutex.new

  # Generate the next n digits of e
  def generate(n)
    start = digits.length

    while digits.length < start + n
      calc
    end
  end

  def digits
    @@digits
  end

  private

  # Run one iteration of the spigot algorithm
  # This may not produce a digit (precision can increase without the lower and upper
  # bounds converging for the next digit
  def calc
    @@state_lock.synchronize do
      @@state = compose(@@state, transformation(@@iteration))

      lower = apply(@@state, LOWER_BOUND).floor
      upper = apply(@@state, UPPER_BOUND).floor

      collect(lower) if lower == upper

      @@iteration += 1
    end
  end

  # Store the digit, then apply a transformation to the state
  # to subtract the value and multiply by 10
  def collect(digit)
    transform = [10, -10 * digit,
                 0,   1]

    digit += 1 if digits.empty? # Algorithm produces e-1 so add 1
    digits.push digit

    @@state = compose(transform, @@state)
  end

  # Gives the transformation matrix for the nth sub-function in the taylor series for e
  def transformation(n)
    [1, 1+n,
     0, 1+n]
  end

  # Apply the mobius transformation to a value representing the tail of the
  # infinite series of transformations (ie a lower or upper bound for the tail)
  #
  # transform is a 2x2 matrix [a, b,
  #                            c, d]
  # value is a scalar
  def apply(transform, value)
    a, b, c, d = transform[0..4]

    Float(a * value + b) / Float(c * value + d)
  end

  # Compose two functions by multiplying their matrix representations
  def compose(m1, m2)
    a, b, c, d = m1[0..4]
    w, x, y, z = m2[0..4]

    [a*w + b*y, a*x + b*z,
     c*w + d*y, c*x + d*z]
  end
end
