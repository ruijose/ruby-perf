require_relative "ruby_perf/version"
require_relative "ruby_perf/parser"
require_relative "ruby_perf/test"
require_relative "ruby_perf/create_csv"
require_relative "ruby_perf/generate_graphs"

module RubyPerf
  def self.execute_test(test_paramaters)
    low_rate = test_paramaters.fetch(:low_rate)
    high_rate = test_paramaters.fetch(:high_rate)
    rate_step = test_paramaters.fetch(:rate_step)

    rates = (low_rate..high_rate).select { |rate|
      rate % rate_step == 0
    }

    rates.each_with_object(Array.new) do |rate, all_test_results|
      test_paramaters[:rate] = rate
      test_results = Test.new(test_paramaters).start_httperf_test
      all_test_results << test_results
    end
  end
end
