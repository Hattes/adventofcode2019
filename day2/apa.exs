defmodule DayTwo do
  def halt(prog, _) do
    elem(prog, 0)
  end
  def add(prog, pos) do
    op1 = elem(prog, elem(prog, pos+1))
    op2 = elem(prog, elem(prog, pos+2))
    dest = elem(prog, pos+3)
    prog2 = put_elem(prog, dest, op1+op2)
    execute(prog2, pos+4)
  end
  def mul(prog, pos) do
    op1 = elem(prog, elem(prog, pos+1))
    op2 = elem(prog, elem(prog, pos+2))
    dest = elem(prog, pos+3)
    prog2 = put_elem(prog, dest, op1*op2)
    execute(prog2, pos+4)
  end
  def execute(prog, pos) do
    if tuple_size(prog) <= pos do
      elem(prog, 0) # This should be the answer
    else
      case elem(prog, pos) do
        99 -> halt(prog, pos)
        1  -> add(prog, pos)
        2  -> mul(prog, pos)
      end
    end
  end
end


inputfile = "input"
body = File.read!(inputfile)
splits = String.split(body, ",", trim: true)
ints = Enum.map(splits, &Integer.parse/1)
ints = Enum.map(ints, fn ({m,_}) -> m end)
ints = List.to_tuple(ints)
ints = put_elem(ints, 1, 12)
ints = put_elem(ints, 2, 2)
answer = DayTwo.execute(ints, 0)
IO.puts("Answer 1 is #{answer}")
#answer2 = DayOne.fuelfueltotal(ms, 0)
#IO.puts("Answer 2 is #{answer2}")
