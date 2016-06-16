require 'csv'

class CreateCsv
  attr_reader :test_results

  def initialize(test_results)
    @test_results = test_results
  end

  def create_csv
    headers = csv_headers
    CSV.open("data.csv", "w", write_headers: true, headers: headers) do |csv|
      test_results.each do |test|
        values = test.values.map { |e| e.split(" ") }.flatten
        csv << values
      end
    end
  end

  def csv_headers
    %w[connections requests replies
       test_duration connection_rate
       connection_time_min connection_time_avg
       connection_time_max connection_time_median
       connection_time_stddev connection_time conn_length
       request_rate reply_rate_min reply_rate_avg
       reply_rate_max reply_rate_stddev reply_time_response
       reply_time_tranfer 1xx_codes 2xx_codes
       3xx_codes 4xx_codes 5xx_codes cpu_user
       cpu_system net_io error_total error_cli_timo
       error_socket_timo error_conn_refused error_conn_reset
       error_fd_unavail error_addrunavail error_ftab-full
       error_other]
  end
end
