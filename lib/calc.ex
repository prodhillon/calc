# HW 04 : Calculator in Elixir
# The code is implemented  using Regex in elixir for checking parantheses and operators.
# It calculates the output w.r.t operator precedence and raise error in case input is not  in proper form
# References taken for learning Elixir and Regex operations:
# https://hexdocs.pm/elixir/Regex.html
# https://elixir-lang.org/getting-started/sigils.html
# https://hexdocs.pm/elixir/Float.html (For Float operations)

defmodule Calc do

 # main method which gets invoked first
  def main() do
    # sends a random number to getinput method for repeatedly printing prompts
    getinput(10)
  end

  # getinput method which gets the input and display the output in loop
  def getinput(n) when n <= 20 do
    getinput = IO.gets(">")
    answer = eval(getinput)
    # if output is same as input which means input is broken, print error
    if(answer == getinput)do
      raise "--> Please enter input in correct format......"
    end
    # display the answer
    IO.puts(answer)
    # decrement the loop parameter to keep on prompting
    getinput(n - 1)
  end

  # eval method to start processing the input. It is entry point and deals with parsing input.
  def eval(inputdata) do
    # concat parantheses to input to keep the consistent method calls
    addparan= Enum.join(["(", inputdata ,")"])
    # remove any spaces in input and pass it to method
    String.replace(addparan," ","")
    |> checkForParantheses()
  end

  # checkForParantheses method checks for parantheses.()
  def checkForParantheses(input) do
    case Regex.match?(~R/\(([^()]+)\)/, input) do
      # if found , remove parantheses, evaluate the result and call the method again
      true -> removeParen(input) |> checkForParantheses()
      # if not found , return the input which will be the final answer
      false -> input
    end
  end

  # removeParen method removes the parantheses using Regex.replace
  def removeParen(input) do
    Regex.replace(~R/\(([^()]+)\)/, input, fn _,
      # after removing parantheses, check for first operation to perform using BODMAS. Multiply first
      x -> checkOperator(x,"*")
    end)
  end

  # compileOperatorRegex method compiles regex for every operator viz., /,+,-,*
  def compileOperatorRegex(operator) do
    case operator do
      "/" -> divregex()
      "+" -> addregex()
      "-" -> subregex()
      "*" -> mulregex()
    end
  end

  # divregex method returns regex for / after compilation
  def divregex() do
    {:ok, regexdiv} = Regex.compile("(\\w+)(\\/)(\\w+)")
    regexdiv
  end

  # mulregex method returns regex for * after compilation
  def mulregex() do
    {:ok, regexmul} = Regex.compile("(\\w+)(\\*)(\\w+)")
    regexmul
  end

  # subregex method returns regex for - after compilation
  def subregex() do
    {:ok, regexsub} = Regex.compile("(\\w+)(\\-)(\\w+)")
    regexsub
  end

  # addregex method returns regex for + after compilation
  def addregex() do
    {:ok, regexadd} = Regex.compile("(\\w+)(\\+)(\\w+)")
    regexadd
  end

  # checkOperator compiles the regex for operator and then check the match
  def checkOperator(input,operator) do
    compileOperatorRegex(operator)
    |> checkOperatorRegex(input, operator)
  end

  # checkOperatorRegex checks operator regex with input
  def checkOperatorRegex(regex, input, operator) do
    case Regex.match?(regex, input) do
      # if matchfound it further processes the input
      true -> checkOperationsMatch(input, operator)
      # else it skips the current operator and check with next one
      false -> checkOperationsSkip(input, operator)
    end
  end

  # checkOperationsSkip method checks for next operator as per operator precedence
  def checkOperationsSkip(input, operator) do
    case operator do
      "*" -> checkOperator(input, "/")
      "/" -> checkOperator(input, "+")
      "+" -> checkOperator(input, "-")
      #if no more operator found in the input, just return the input
      "-" -> input
    end
  end

  # checkOperationsMatch calls method to perform arithmetic operations.
  def checkOperationsMatch(input, operator) do
      performOperations(input, operator)
      |> checkOperator(operator)
  end

  # performOperations gets the numbers before and after operator using regex.replace
  def performOperations(input, operator) do
    compileOperatorRegex(operator)
    |> Regex.replace(input, fn _,
    beforeOp, operator, afterOp -> calculateResult(beforeOp, operator, afterOp)
    end)
  end

  # calculateResult method performs arithmetic calculations using Enum.reduce
  def calculateResult(beforeOp, operator, afterOp) do
    list=[beforeOp] ++ [afterOp]
    [head | tail] = list
    case operator do
      "*" -> "#{Enum.reduce(tail, format(head), fn(x, acc) -> acc * format(x)  end) |> round}"
      "/" -> "#{Enum.reduce(tail, format(head), fn(x, acc) -> acc / format(x)  end) |> round}"
      "+" -> "#{Enum.reduce(tail, format(head), fn(x, acc) -> acc + format(x)  end) |> round}"
      "-" -> "#{Enum.reduce(tail, format(head), fn(x, acc) -> acc - format(x)  end) |> round}"
    end
  end

  # format method returns the float value of data.
  def format(data) do
    {flt, _ } = Float.parse(data)
    flt
  end

end
