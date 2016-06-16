require_relative "ruby_perf/version"
require_relative "ruby_perf/parser"
require_relative "ruby_perf/test"
require_relative "ruby_perf/create_csv"

module RubyPerf
  def self.execute_test(test_paramaters)
    low_rate = test_paramaters.fetch(:low_rate)
    high_rate = test_paramaters.fetch(:high_rate)
    rate_step = test_paramaters.fetch(:rate_step)

    rates = (low_rate..high_rate).select { |rate|
      rate % rate_step == 0
    }

    all_test_results = Array.new

    rates.each do |rate|
      h = test_paramaters.tap { |h|
        h.delete(:low_rate); h.delete(:high_rate); h.delete(:rate_step)
      }
      h[:rate] = rate
      test_results = Test.new(h).start_httperf_test
      all_test_results << test_results
    end

    CreateCsv.new(all_test_results).create_csv
  end
end
