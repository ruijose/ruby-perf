require 'spec_helper'

describe Parser do

  before {
    @test_result_1 = ["httperf --timeout=5 --client=0/1 --server=130.211.57.135 --port=4567 --uri=/hyperty/user/ruimangas@inesc-id.pt --rate=200 --send-buffer=4096 --recv-buffer=16384 --num-conns=50 --num-calls=1", "Maximum connect burst length: 1", "", "Total: connections 50 requests 50 replies 50 test-duration 0.310 s", "", "Connection rate: 161.5 conn/s (6.2 ms/conn, <=16 concurrent connections)", "Connection time [ms]: min 63.8 avg 67.6 max 77.4 median 67.5 stddev 2.7", "Connection time [ms]: connect 31.3", "Connection length [replies/conn]: 1.000", "", "Request rate: 161.5 req/s (6.2 ms/req)", "Request size [B]: 101.0", "", "Reply rate [replies/s]: min 0.0 avg 0.0 max 0.0 stddev 0.0 (0 samples)", "Reply time [ms]: response 36.3 transfer 0.0", "Reply size [B]: header 111.0 content 176.0 footer 2.0 (total 289.0)", "Reply status: 1xx=0 2xx=50 3xx=0 4xx=0 5xx=0", "", "CPU time [s]: user 0.05 system 0.26 (user 16.8% system 82.7% total 99.5%)", "Net I/O: 61.2 KB/s (0.5*10^6 bps)", "", "Errors: total 0 client-timo 0 socket-timo 0 connrefused 0 connreset 0", "Errors: fd-unavail 0 addrunavail 0 ftab-full 0 other 0"]
  }

  it 'should parse test results' do
    parsed_result = Parser.new.parse_test_result(@test_result_1)
    expected_result = {"connections"=>50, "requests"=>50, "replies"=>50, "test_duration"=>0.31, "connection_rate"=>161.5, "connection_time_min"=>63.8, "connection_time_avg"=>67.6, "connection_time_max"=>77.4, "connection_time_median"=>67.5, "connection_time_stddev"=>2.7, "connection_time"=>31.3, "conn_length"=>1.0, "request_rate"=>161.5, "reply_rate_min"=>0.0, "reply_rate_avg"=>0.0, "reply_rate_max"=>0.0, "reply_rate_stddev"=>0.0, "reply_time_response"=>36.3, "reply_time_tranfer"=>0.0, "1xx_codes"=>0, "2xx_codes"=>50, "3xx_codes"=>0, "4xx_codes"=>0, "5xx_codes"=>0, "cpu_user"=>0.05, "cpu_system"=>0.26, "net_io"=>61.2, "error_total"=>0, "error_cli_timo"=>0, "error_socket_timo"=>0, "error_conn_refused"=>0, "error_conn_reset"=>0, "error_fd_unavail"=>0, "error_addrunavail"=>0, "error_ftab-full"=>0, "error_other"=>0}

    expect(parsed_result).to eql(expected_result)
  end
end
