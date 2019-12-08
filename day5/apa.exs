defmodule Day5 do
  def halt(prog, _) do
    elem(prog, 0)
  end
  def getVal(prog, num, 0) do
    # Position mode
    elem(prog, num)
  end
  def getVal(_, num, 1) do
    # Immediate mode
    num
  end
  def getOps(prog, pos, {modeP1, modeP2, modeP3}) do
    # Assume three operands
    IO.puts("mode is #{modeP1}")
    num1 = elem(prog, pos+1)
    op1 = getVal(prog, num1, modeP1)
    num2 = elem(prog, pos+2)
    op2 = getVal(prog, num2, modeP2)
    num3 = elem(prog, pos+3)
    dest = getVal(prog, num3, modeP3)
    {op1, op2, dest}
  end
  def add(prog, pos, mode) do
    {op1, op2, dest} = getOps(prog, pos, mode)
    prog2 = put_elem(prog, dest, op1+op2)
    {prog2, pos+4}
  end
  def mul(prog, pos, _mode) do
    op1 = elem(prog, elem(prog, pos+1))
    op2 = elem(prog, elem(prog, pos+2))
    dest = elem(prog, pos+3)
    prog2 = put_elem(prog, dest, op1*op2)
    {prog2, pos+4}
  end
  def getMode(modeNumber) do
    { rem(div(modeNumber, 100), 10),
      rem(div(modeNumber, 1000), 10),
      div(modeNumber, 10000)}
  end
  def input(prog, pos) do
    {prog, pos}
   # op1 = elem(prog, elem(prog, pos+1))
   #kk op2 = elem(prog, elem(prog, pos+2))
  end
  def output(prog, pos) do
    {prog, pos}
  end
  def execute(prog, pos) do
    spec = elem(prog, pos)
    IO.puts(spec)
    opcode = rem(spec, 100)
    IO.puts(opcode)
    case opcode do
      99 -> halt(prog, pos)
      3  -> input(prog, pos)
            execute(prog, pos+3)
      4  -> output(prog, pos)
            execute(prog, pos+3)
      _  -> mode = getMode(spec)
            IO.inspect(mode)
            IO.inspect(pos)
            case opcode do
              1  -> handleInstr(&add/3, prog, pos, mode)
              2  -> handleInstr(&mul/3, prog, pos, mode)
              _  -> execute(prog, pos+1)  # Just skip it
            end
    end
  end
  def handleInstr(instr, prog, pos, mode) do
    {newprog, newpos} = instr.(prog, pos, mode)
    execute(newprog, newpos)
  end
  def pass(prog, noun, verb) do
    localprog = put_elem(put_elem(prog, 1, noun), 2, verb)
    case execute(localprog, 0) do
      19690720 -> true
      _        -> false
    end
  end
  def loop(prog, noun, verb) do
    case pass(prog, noun, verb) do
      true  -> noun * 100 + verb
      false -> case noun do
                99  -> loop(prog, 0, verb+1)
                _   -> loop(prog, noun+1, verb)
      end
    end
  end
  def getInput() do
    getInput("input")
  end
  def getTestInput() do
    getInput("testinput")
  end
  def getInput(filename) do
    File.read!(filename) |>
    String.split(",", trim: true) |>
    Enum.map(&Integer.parse/1)|>
    Enum.map(fn ({m,_}) -> m end)|>
    List.to_tuple()
  end
end
