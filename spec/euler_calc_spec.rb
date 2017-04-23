E_DIGITS = [2, 7, 1, 8, 2, 8, 1, 8, 2, 8, 4, 5, 9, 0, 4, 5, 2, 3, 5, 3, 6, 0, 2, 8, 7,
            4, 7, 1, 3, 5, 2, 6, 6, 2, 4, 9, 7, 7, 5, 7, 2, 4, 7, 0, 9, 3, 6, 9, 9, 9,
            5, 9, 5, 7, 4, 9, 6, 6, 9, 6, 7, 6, 2, 7, 7, 2, 4, 0, 7, 6, 6, 3, 0, 3, 5]

describe EulerCalc do
  before do
    @ec = EulerCalc.new
  end

  describe "#generate" do
    it "produces n digits of e" do
      @ec.generate(3)

      expect(@ec.digits.length).to eq(3)
      expect(@ec.digits).to eq(E_DIGITS[0..2])
    end

    it "appends additional digits" do
      @ec.generate(3)

      expect(@ec.digits.length).to eq(6)
      expect(@ec.digits).to eq(E_DIGITS[0..5])
    end

    it "gives more digits than a double-precision float" do
      @ec.generate(30)

      expect(@ec.digits.length).to eq(36)
      expect(@ec.digits).to eq(E_DIGITS[0...36])
    end
  end

  describe "#substring" do
    it "gives the appropriate number" do
      int = @ec.substring(0, 3)

      expect(int).to eq(271)
    end

    it "generates needed digits if they don't exist" do
      int = @ec.substring(30, 10)

      expect(@ec.digits.length).to eq(40)
      expect(int.to_s.length).to eq(10)
    end
  end
end
