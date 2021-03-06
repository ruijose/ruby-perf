require 'json'

class Parser
  def parse_test_result(results_obtained)
    clean_output = clean_empty_lines(results_obtained)
    hash_results = test_results_to_hash(clean_output)
    remaining = remove_unnecessary_symbols(hash_results)

    csv_headers.zip(remaining).to_h.reduce(Hash.new(0)) do |h, (k,v)|
      h[k] = v.include?(".") ? v.to_f : v.to_i ; h
    end
  end

  def unimportant_params
    ["Reply size [B]", "Request size [B]"]
  end

  private

  def clean_empty_lines(output)
    result = output.reject { |line| line.empty? }
    remove_first_two_lines(result)
  end

  def remove_first_two_lines(array)
    array.drop(2)
  end

  def test_results_to_hash(results)
    results.each_with_object(Hash.new(0)) do |str, res|
      metric, result = str.split(":")
      next if unimportant_params.any? { |param| metric == param }

      if res.keys.include? metric
        res["#{metric}_2"] = result
      else
        res[metric] = result
      end
    end
  end

  def remove_unnecessary_symbols(test_hash_results)
    h = test_hash_results.map { |k, v|
      [k, remove_symbols(v)]
    }.to_h

    handle_reply_status_field(h).values.map { |e|
      e.split(" ")
    }.flatten
  end

  def remove_symbols(string)
    remove_string_parentheses(string).chars.reject { |e|
      element_verification(e)
    }.join.strip
  end

  def remove_string_parentheses(string)
    string.gsub(/\(.*\)/, "")
  end

  def symbols_to_remove
    ["/", "-"]
  end

  def letters_to_remove
    alphabet = ("a".."z").to_a
    alphabet + alphabet.map(&:upcase)
  end

  def element_verification(element)
    [letters_to_remove, symbols_to_remove].any? do |array|
      array.include?(element)
    end
  end

  def handle_reply_status_field(hash)
    hash.map { |k,v|
      if k == "Reply status"
        [k, v.gsub(/[0-9]+\=/, "")]
      else
        [k, v]
      end
    }.to_h
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
