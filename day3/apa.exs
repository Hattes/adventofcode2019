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
  def getcoordsposandsteps(stretch, pos, steps) do
    case stretch do
      {:up, length}     -> goupsteps(length, pos, steps)
      {:down, length}   -> godownsteps(length, pos, steps)
      {:left, length}   -> goleftsteps(length, pos, steps)
      {:right, length}  -> gorightsteps(length, pos, steps)
    end
  end
  def goup(len, {x,y}), do: {Enum.map(1..len, fn i    -> {x,y-i} end), {x,y-len}}
  def godown(len, {x,y}), do: {Enum.map(1..len, fn i  -> {x,y+i} end), {x,y+len}}
  def goleft(len, {x,y}), do: {Enum.map(1..len, fn i  -> {x-i,y} end), {x-len,y}}
  def goright(len, {x,y}), do: {Enum.map(1..len, fn i -> {x+i,y} end), {x+len,y}}
  def goupsteps(len, {x,y}, steps) do
    {Enum.map(1..len, fn i -> {x,y-i,steps+i} end), {x,y-len},steps+len}
  end
  def godownsteps(len, {x,y}, steps) do
    {Enum.map(1..len, fn i  -> {x,y+i,steps+i} end), {x,y+len},steps+len}
  end
  def goleftsteps(len, {x,y}, steps) do
    {Enum.map(1..len, fn i  -> {x-i,y,steps+i} end), {x-len,y},steps+len}
  end
  def gorightsteps(len, {x,y}, steps) do
    {Enum.map(1..len, fn i -> {x+i,y,steps+i} end), {x+len,y},steps+len}
  end
  def traverse([], _) do
    []
  end
  def traverse([stretch|ss], pos) do
    {coords, newpos} = getcoordsandpos(stretch, pos)
    coords ++ traverse(ss, newpos)
  end
  def traversewithsteps([], _, _) do
    []
  end
  def traversewithsteps([stretch|ss], pos, steps) do
    {coords, newpos, newsteps} = getcoordsposandsteps(stretch, pos, steps)
    coords ++ traversewithsteps(ss, newpos, newsteps)
  end
  def work({wire1, wire2}) do
    {Enum.sort(traverse(wire1, {0,0})), Enum.sort(traverse(wire2, {0,0}))}
  end
  def work2({wire1, wire2}) do
    {Enum.sort(traversewithsteps(wire1, {0,0}, 0), &sortfun/2),
     Enum.sort(traversewithsteps(wire2, {0,0}, 0), &sortfun/2)}
  end
  def sortfun({ax,ay,_},{bx,by,_}) do
    {ax,ay} <= {bx,by}
  end
  def findmatch([], [], lowest), do: lowest
  def findmatch(_, [], lowest), do: lowest
  def findmatch([], _, lowest), do: lowest
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
  def findmatchst([], [], lowest), do: lowest
  def findmatchst(_, [], lowest), do: lowest
  def findmatchst([], _, lowest), do: lowest
  def findmatchst([{0,0,0}|as], bs, lowest) do
    findmatchst(as,bs, lowest)
  end
  def findmatchst(as, [{0,0,0}|bs], lowest) do
    findmatchst(as,bs, lowest)
  end

  def findmatchst(ass,bss,lowest) do
    [a|as] = ass
    [b|bs] = bss
    {ax,ay,ast} = a
    {bx,by,bst} = b
    cond do
      {ax,ay} < {bx,by} -> findmatchst(as, bss, lowest)
      {ax,ay} > {bx,by} -> findmatchst(ass, bs, lowest)
      true              -> cand = ast + bst
                           case lowest do
                             nil -> findmatchst(as,bs,cand)
                             _   -> findmatchst(as,bs,min(lowest,cand))
                           end
    end
  end
  def answerone() do
    getinput()|>workone()
  end
  def workone(input) do
    getdata(input)|>parsedata()|>work()|>
    (fn({a,b})->findmatch(a,b,nil)end).()
  end
  def answertwo() do
    getinput()|>worktwo()
  end
  def worktwo(input) do
    getdata(input)|>parsedata()|>work2()|>
    (fn({a,b})->findmatchst(a,b,nil)end).()
  end
end

