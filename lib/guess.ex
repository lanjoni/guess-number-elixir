defmodule Guess do
  use Application

  def start(_,_) do
    run()
    {:ok, self()}
  end

  def run() do
    IO.puts("Let's play Guess the Number!")

    IO.gets("Pick a difficult level (1, 2 or 3): ")
    |> parseInput()
    |> pickUpNumber()
    |> play()
  end

  def pickeds(user_guess, inputs) do
    if Enum.member?(inputs, user_guess) do
      IO.puts("This number has already been chosen before!")
      inputs
    else
      inputs = inputs ++ [user_guess]
      inputs
    end
  end

  def play(picked) do
    inputs = [0]
    IO.gets("Okay, I have my number... What is your guess?\n")
    |> parseInput()
    |> guess(picked, 1, inputs)
  end

  def guess(user_guess, picked, count, inputs) when user_guess > picked do
    inputs = pickeds(user_guess, inputs)
    IO.gets("Too high... Try againg: ")
    |> parseInput()
    |> guess(picked, count + 1, inputs)
  end

  def guess(user_guess, picked, count, inputs) when user_guess < picked do
    inputs = pickeds(user_guess, inputs)
    IO.gets("Too low... Try againg: ")
    |> parseInput()
    |> guess(picked, count + 1, inputs)
  end

  def guess(_user_guess, _picked, count, _inputs) do
    IO.puts("Congrats! You got it! #{count} times...")
    showScore(count)
  end

  def showScore(guesses) when guesses > 6 do
    IO.puts("Better luck next time!")
  end

  def showScore(guesses) do
    {_, msg} = %{
      1..1 => "You're a mind river!",
      2..4 => "Most impressive!",
      3..6 => "You can do better than that..."
    }
    |> Enum.find(fn {range, _} ->
      Enum.member?(range, guesses)
    end)

    IO.puts(msg)
  end

  def parseInput(:error) do
    IO.puts("Invalid input!")
    run()
  end

  def parseInput({num, _}), do: num

  def parseInput(data) do
    data
    |> Integer.parse()
    |> parseInput()
  end

  def getRange(level) do
    case level do
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      _ -> IO.puts("Invalid level!")
        run()
    end
  end

  def pickUpNumber(level) do
    level
    |> getRange()
    |> Enum.random()
  end
end
