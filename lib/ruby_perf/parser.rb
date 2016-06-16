require 'json'

class Parser
  def parse_test_result(results_obtained)
    each_result_line = results_obtained.split("\n")
    clean_output = clean_empty_lines(each_result_line)
    h = test_results_to_hash(clean_output)
    remove_unnecessary_info(h)
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
      res[metric] = result
    end
  end

  def remove_unnecessary_info(test_hash_results)
    test_hash_results.map { |k, v|
      [k, remove_string_parentheses(v)]
    }.to_h
  end

  def remove_string_parentheses(string)
    string.strip.gsub(/\(.*?\)/, "")
  end

  def unimportant_params
    ["Reply size [B]", "Request size [B]"]
  end
end
