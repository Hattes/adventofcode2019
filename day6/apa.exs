defmodule Day6 do
  def getInput(filename) do
    File.read!(filename) |>
    String.split()|>
    Enum.map(fn (a) -> String.split(a, ")")|>List.to_tuple() end)
    #Enum.into(%{}) # make it a map, i.e. lookupable
  end
  def mapify(orbitlist) do
    Enum.group_by(orbitlist, (fn {a,_} -> a end), (fn {_,b} -> b end))
  end
  def getInput() do
    getInput("input")
  end
  def bodies(orbits) do
    bodies(orbits, MapSet.new())
  end
  def bodies([{b1,b2}|orbits], bs) do
    bs2 = MapSet.put(bs, b1) |> MapSet.put(b2)
    bodies(orbits, bs2)
  end
  def bodies([], bs) do
    bs
  end
  def treeify(orbitMap) do
    # Make a tree of the data
    treeify(orbitMap, "COM")
  end
  def treeify(orbitMap, prim) do
    # The body which a satellite orbits is called a "primary"
    sats = Map.get(orbitMap, prim, [])
    {prim, (for sat <- sats, do: treeify(orbitMap, sat))}
  end
  def countOrbits({_, []}) do
    1
  end
  def countOrbits(orbitMap) do
    countOrbits(orbitMap, 0)
  end
  def countOrbits({"COM", rest}, total) do
    Enum.sum(Enum.map(rest, (fn a -> countOrbits(a, total) end)))
  end
  def countOrbits({_, rest}, total) do
    newTotal = total + 1
    newTotal + Enum.sum(Enum.map(rest, (fn a -> countOrbits(a, newTotal) end)))
  end
  def answerOne() do
    getInput()|>mapify()|>treeify()|>countOrbits()
  end
  def answerTwo() do
  end
end
