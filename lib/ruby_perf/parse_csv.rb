require 'csv'

class ParseCsv
  TESTS_TYPES = %w[1__2000 2__2000 3__2000]

  def parse
    TESTS_TYPES.each do |test_type_name|
      files_to_parse = select_files(test_type_name)
      array_all_rows = analyse_csvs(to_analyse)
      joined_rows = join_rows_from_different_csvs(array_all_rows)
      final_values = average(joined_rows)
      create_csv(final_values, test_type_name)
    end
  end

  private

  def select_files(csv_part_name)
    Dir.entries("/reports").select do |file|
      file.include? csv_part_name
    end
  end

  def analyse_csvs(files)
    files.each_with_object(Array.new) do |csv_file, res|
      res << handle_single_csv(csv_file)
    end
  end

  def handle_single_csv(csv)
    csv_path = "reports/#{csv}"
    csv_columns = Array.new
    puts "#{csv_path} " << File.open(csv_path).readlines.size.to_s
    CSV.foreach(csv_path) do |row|
      csv_columns << [row]
    end
    csv_columns.flatten(2).map { |csv_row|
      csv_row = csv_row.split("\t")
    }
  end

  def join_rows_from_different_csvs(rows)
    rows.each_with_object(Hash.new{|hsh,key| hsh[key] = [] }) do |row, res|
      (0..35).each do |i| # 36 metrics
        res[i] << row[i]
      end
    end
  end

  def average(joined_rows)
    joined_rows.each_with_object(Array.new) do |(_, value), res|
      res << average_arrays(value)
    end
  end

  def average_arrays(a)
    head, *rest = a
    head.zip(*rest).map { |array| array.reduce(:+) / array.size }
  end

  def create_csv(final_values, name)
    CSV.open("reports/final/#{name}_final.csv", "wb") do |csv|
      final_values.each { |row| csv << row }
    end
  end
end
