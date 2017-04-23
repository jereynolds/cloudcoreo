describe PrimeChecker do
  describe "#check" do
    before do
      @pc = PrimeChecker.new
      @pc.reset
    end

    it "identifies a prime from the list" do
      expect(@pc.check(3)).to be true
    end

    it "extends the known primes list" do
      @pc.check 11

      expect(@pc.primes.length).to eq(5)
    end
  end
end
