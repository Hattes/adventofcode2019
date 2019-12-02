defmodule DayOne do
  def fuel(mass) do
    div(mass, 3) -2
  end
  def fuelfuel(mass) do
    _fuelfuel(mass, 0)
  end
  def _fuelfuel(mass, acc) do
    fuel1 = div(mass, 3) -2
    case fuel1 do
      x when x <= 0 ->
        acc
      _ ->
        _fuelfuel(fuel1, acc + fuel1)
    end
  end
  def fueltotal([], acc) do
    acc
  end
  def fueltotal([m|ms], acc) do
    fueltotal(ms, acc + fuel(m))
  end
  def fuelfueltotal([], acc) do
    acc
  end
  def fuelfueltotal([m|ms], acc) do
    fuelfueltotal(ms, acc + fuelfuel(m))
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
IO.puts("Answer 1 is #{answer}")
answer2 = DayOne.fuelfueltotal(ms, 0)
IO.puts("Answer 2 is #{answer2}")
