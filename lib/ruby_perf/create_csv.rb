require 'csv'

class CreateCsv
  attr_reader :test_results

  def initialize(test_results)
    @test_results = test_results
  end

  def create_csv
    headers = test_results.first.keys
    CSV.open("data.csv", "w", write_headers: true, headers: headers) do |csv|
      test_results.each do |test|
        csv << test.values
      end
    end
  end
end
