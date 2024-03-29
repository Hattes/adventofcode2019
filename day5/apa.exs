defmodule Day5 do
  def halt(_, _) do
    nil
  end
  def getVal(prog, num, 0) do
    # Position mode
    elem(prog, num)
  end
  def getVal(_, num, 1) do
    # Immediate mode
    num
  end
  def getOps(prog, pos, {modeP1, modeP2, _modeP3}) do
    # Assume three operands
    num1 = elem(prog, pos+1)
    op1 = getVal(prog, num1, modeP1)
    num2 = elem(prog, pos+2)
    op2 = getVal(prog, num2, modeP2)
    num3 = elem(prog, pos+3)
    dest = num3  # Always "position", though really kinda immediate
    {op1, op2, dest}
  end
  def add(prog, pos, mode) do
    {op1, op2, dest} = getOps(prog, pos, mode)
    prog2 = put_elem(prog, dest, op1+op2)
    {prog2, pos+4}
  end
  def mul(prog, pos, mode) do
    {op1, op2, dest} = getOps(prog, pos, mode)
    prog2 = put_elem(prog, dest, op1*op2)
    {prog2, pos+4}
  end
  def jit(prog, pos, mode) do
    {op1, op2, _dest} = getOps(prog, pos, mode)
    if op1 != 0 do
      {prog, op2}
    else
      {prog, pos+3}
    end
  end
  def jif(prog, pos, mode) do
    {op1, op2, _dest} = getOps(prog, pos, mode)
    if op1 == 0 do
      {prog, op2}
    else
      {prog, pos+3}
    end
  end
  def les(prog, pos, mode) do
    {op1, op2, dest} = getOps(prog, pos, mode)
    if op1 < op2 do
      newprog = put_elem(prog, dest, 1)
      {newprog, pos+3}
    else
      newprog = put_elem(prog, dest, 0)
      {newprog, pos+3}
    end
  end
  def equ(prog, pos, mode) do
    {op1, op2, dest} = getOps(prog, pos, mode)
    if op1 == op2 do
      newprog = put_elem(prog, dest, 1)
      {newprog, pos+3}
    else
      newprog = put_elem(prog, dest, 0)
      {newprog, pos+3}
    end
  end
  def getMode(modeNumber) do
    { rem(div(modeNumber, 100), 10),
      rem(div(modeNumber, 1000), 10),
      div(modeNumber, 10000)}
  end
  def input(prog, pos) do
    value = IO.gets("input: ")|>String.trim|>
                                Integer.parse|>(fn ({m,_}) -> m end).()
    op = elem(prog, pos+1)
    newprog = put_elem(prog, op, value)
    execute(newprog, pos+2)
  end
  def output(prog, pos, mode) do
    op = getVal(prog, elem(prog, pos+1), mode)
    IO.puts(op)
    execute(prog, pos+2)
  end
  def execute(prog, pos) do
    spec = elem(prog, pos)
    opcode = rem(spec, 100)
    case opcode do
      99 -> halt(prog, pos)
      3  -> input(prog, pos)
      _  -> mode = getMode(spec)
            case opcode do
              1  -> handleInstr(&add/3, prog, pos, mode)
              2  -> handleInstr(&mul/3, prog, pos, mode)
              4  -> output(prog, pos, elem(mode, 0))
              5  -> handleInstr(&jit/3, prog, pos, mode)
              6  -> handleInstr(&jif/3, prog, pos, mode)
              7  -> handleInstr(&les/3, prog, pos, mode)
              8  -> handleInstr(&equ/3, prog, pos, mode)
              _  -> execute(prog, pos+1)  # Just skip it
            end
    end
  end
  def handleInstr(instr, prog, pos, mode) do
    {newprog, newpos} = instr.(prog, pos, mode)
    execute(newprog, newpos)
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
  def answer() do
    getInput() |> execute(0)
  end
end
