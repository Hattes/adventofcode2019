defmodule Day6 do
  def getInput(filename) do
    File.read!(filename) |>
    String.split()|>
    Enum.map(fn (a) -> String.split(a, ")")|>List.to_tuple() end)|>
    Enum.into(%{}) # make it a map, i.e. lookupable
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
  def treeify(orbits) do
    # Make a tree of the data
    treeify(orbits, "COM", {})
  end
  def treeify(orbits, prim, tree) do
    # The body which a satellite orbits is called a "primary"
    sat = orbits[prim]
    case sat do
      nil -> tree  # we should be done
      #_   -> treeify(orbits, sat, {prim, 
    end
    tree
  end
  def answerOne() do
  end
  def answerTwo() do
  end
end
