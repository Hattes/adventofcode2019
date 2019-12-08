defmodule Day4 do
  def meets(number) do
    ss = makeSs number
    hasPair(ss) and isRising(ss)
  end
  def meets2(number) do
    ss = makeSs number
    hasExactPair(ss) and isRising(ss)
  end
  def hasPair([a|[b|[c|[d|[e|[f|[]]]]]]] ) do
    (a == b or b == c or c == d or d == e or e == f)
  end
  def hasExactPair([a|[b|[c|[d|[e|[f|[]]]]]]] ) do
    (a == b and b != c) or
    (a != b and b == c and c != d) or
    (b != c and c == d and d != e) or
    (c != d and d == e and e != f) or
    (d != e and e ==f)
  end
  def isRising([a|[b|[c|[d|[e|[f|[]]]]]]]) do
    a <= b and b <= c and c <= d and d <= e and e <= f
  end
  def getInput(), do: 128392..643281
  def answerOne() do
    length(for n <-getInput(), meets(n), do: n)
  end
  def answerTwo() do
    length(for n <-getInput(), meets2(n), do: n)
  end
  def makeSs(number) do
    String.graphemes Integer.to_string number
  end
end
