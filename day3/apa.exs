defmodule DayThree do
  def getinput() do
    inputfile = "input"
    File.read!(inputfile)
  end
  def gettestinput() do
    inputfile = "testinput"
    File.read!(inputfile)
  end
  def basicinput() do
    inputfile = "basicinput"
    File.read!(inputfile)
  end
  def getdata(rawdata) do
    [line1, line2] = String.split(rawdata, "\n", trim: true)
    wire1 = String.split(line1, ",", trim: true)
    wire2 = String.split(line2, ",", trim: true)
    {wire1, wire2}
  end
  def parse(stretch_str) do
    case stretch_str do
      "U" <> length -> {:up, String.to_integer(length)}
      "R" <> length -> {:right, String.to_integer(length)}
      "L" <> length -> {:left, String.to_integer(length)}
      "D" <> length -> {:down, String.to_integer(length)}
    end
  end
  def parsedata({wire1, wire2}) do
    {Enum.map(wire1, &parse/1), Enum.map(wire2, &parse/1)}
  end
  def getcoordsandpos(stretch, pos) do
    case stretch do
      {:up, length}     -> goup(length, pos)
      {:down, length}   -> godown(length, pos)
      {:left, length}   -> goleft(length, pos)
      {:right, length}  -> goright(length, pos)
    end
  end
  def goup(len, {x,y}), do: {Enum.map(0..len, fn i    -> {x,y-i} end), {x,y-len}}
  def godown(len, {x,y}), do: {Enum.map(0..len, fn i  -> {x,y+i} end), {x,y+len}}
  def goleft(len, {x,y}), do: {Enum.map(0..len, fn i  -> {x-i,y} end), {x-len,y}}
  def goright(len, {x,y}), do: {Enum.map(0..len, fn i -> {x+i,y} end), {x+len,y}}
  def traverse([], _) do
    []
  end
  def traverse([stretch|ss], pos) do
    {coords, newpos} = getcoordsandpos(stretch, pos)
    coords ++ traverse(ss, newpos)
  end
  def work({wire1, wire2}) do
    {Enum.sort(traverse(wire1, {0,0})), Enum.sort(traverse(wire2, {0,0}))}
  end
  def findmatch([], [], lowest) do
    lowest
  end
  def findmatch(_, [], lowest) do
    lowest
  end
  def findmatch([], _, lowest) do
    lowest
  end
  def findmatch([{0,0}|as], bs, lowest) do
    findmatch(as,bs, lowest)
  end
  def findmatch(as, [{0,0}|bs], lowest) do
    findmatch(as,bs, lowest)
  end

  def findmatch(ass,bss,lowest) do
    [a|as] = ass
    [b|bs] = bss
    cond do
      a < b -> findmatch(as, bss, lowest)
      a > b -> findmatch(ass, bs, lowest)
      true  -> {x,y} = a
               cand = abs(x) + abs(y)
               case lowest do
                 nil -> findmatch(as,bs,cand)
                 _   -> findmatch(as,bs,min(lowest,cand))
               end
    end
  end
  def answerone() do
    getinput()|>workone()
  end
  def workone(input) do
    getdata(input)|>
    parsedata()|>
    work()|>
    (fn({a,b})->findmatch(a,b,nil)end).()
  end
end


#ints = Enum.map(splits, &Integer.parse/1)
#ints = Enum.map(ints, fn ({m,_}) -> m end)
#ints = List.to_tuple(ints)
#answer = DayTwo.execute(part1ints, 0)
#IO.puts("Answer 1 is #{answer}")
#answer2 = DayTwo.loop(ints, 0, 0)
#IO.puts("Answer 2 is #{answer2}")
