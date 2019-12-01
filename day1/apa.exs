defmodule DayOne do
  def fuel(mass) do
    div(mass, 3) -2
  end
  def fueltotal([], acc) do
    acc
  end
  def fueltotal([m|ms], acc) do
    fueltotal(ms, acc + fuel(m))
  end
end


inputfile = "input"
body = File.read!(inputfile)
splits = String.split(body, "\n", trim: true)
ms = Enum.map(splits,
                       &Integer.parse/1)
ms = Enum.map(ms, fn ({m,_}) -> m end)
#              fn ({m,_}) -> m end)
answer = DayOne.fueltotal(ms, 0)
IO.puts("Answer is #{answer}")
