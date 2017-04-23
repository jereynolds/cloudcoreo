RESULT_1 = {
  :length => 1,
  :location => 1,
  :prime => 2,
  :position => 0
}

RESULT_2 = {
  :length => 2,
  :location => 3,
  :prime => 23,
  :position => 16
}

describe EulerPrimeJob do

  describe "#execute" do
    it "is only valid with integers" do
      job = EulerPrimeJob.new("a string", 1)
      expect(job).to_not be_valid

      job2 = EulerPrimeJob.new(1, 1)
      expect(job2).to be_valid
    end

    it "finds the first prime" do
      job = EulerPrimeJob.new(RESULT_1[:location], RESULT_1[:length])

      job.execute

      expect(job.result[:prime]).to eq(RESULT_1[:prime])
      expect(job.result[:position]).to eq(RESULT_1[:position])
    end

    it "finds a later, longer prime" do
      job = EulerPrimeJob.new(RESULT_2[:location], RESULT_2[:length])

      job.execute

      expect(job.result[:prime]).to eq(RESULT_2[:prime])
      expect(job.result[:position]).to eq(RESULT_2[:position])
    end
  end
end
