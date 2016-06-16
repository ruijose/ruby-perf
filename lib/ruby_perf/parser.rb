require 'json'

class Parser
  def parse_test_result(results_obtained)
    each_result_line = results_obtained.split("\n")
    clean_output = clean_empty_lines(each_result_line)
    hash_results = test_results_to_hash(clean_output)
    results = remove_unnecessary_info(h)
    remove_special_chars(results)
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

  def remove_unnecessary_info(test_hash_results)
    test_hash_results.map { |k, v|
      [k, remove_string_parentheses(v)]
    }.to_h
  end

  def remove_string_parentheses(string)
    string.gsub(/\(.*\)/, "").chars.reject { |e|
      [("a".."z").map(&:upcase).to_a, ("a".."z").to_a, ["/", "-"]].any? do |el|
        el.include?(e)
      end
    }.join.strip
  end

  def unimportant_params
    ["Reply size [B]", "Request size [B]"]
  end

  def remove_special_chars(hash)
    hash.map { |k,v|
      if k == "Reply status"
        [k, v.gsub(/[0-9]+\=/, "")]
      else
        [k, v]
      end
    }.to_h
  end
end
