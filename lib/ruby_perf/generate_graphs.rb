class GenerateGraph
  def generate_graph(data)
    c1 = 1
    c2 = 2
    IO.popen("gnuplot", "w") { |io| io.puts commands(c1, c2) }
  end

  def commands(column_1, column_2)
    %Q(
      set terminal pdf
      set output "g.pdf"
      set title "gnuplot ruby test"
      set xlabel 'req performed'
      set ylabel 'Average resp time (ms)'
      set datafile separator ","
      plot "data.csv" using #{column_1}:#{column_2} with lines title ""
      exit
    )
  end
end
