class GenerateGraph
  attr_reader :plot_type

  def initialize(plot_type)
    @plot_type = plot_type
  end

  def generate_graph
    IO.popen("gnuplot", "w") { |io| io.puts commands }
  end

  private

  def commands
    column_x_number, x_axis_name = plot_type.fetch("c1")
    column_y_number, y_axis_name = plot_type.fetch("c2")

    %Q(
      set terminal pdf
      set output "#{y_axis_name}__#{y_axis_name}.pdf"
      set xlabel #{x_axis_name}
      set ylabel #{y_axis_name}
      set datafile separator ","
      plot "data.csv" using #{column_1_index}:#{column_2_index} with lines title ""
      exit
    )
  end
end
