class GenerateGraph
  attr_reader :plot_type

  def initialize(plot_type)
    @plot_type = plot_type
  end

  def generate_graph
    IO.popen("gnuplot", "w") { |io| io.puts commands }
  end

  private

  def commands(x, y)
    column_x_number, x_axis_name = plot_type.fetch(x), x
    column_y_number, y_axis_name = plot_type.fetch(y), y

    %Q(
      set terminal pdf
      set output "#{y_axis_name}__#{x_axis_name}.pdf"
      set xlabel "#{x_axis_name}"
      set ylabel "#{y_axis_name}"
      set datafile separator ","
      plot 'reports/test_results_17-06_15-57.csv' using #{column_x_number}:#{column_y_number} with lines title ""
      exit
    )
  end
end
