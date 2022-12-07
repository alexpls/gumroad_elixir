defmodule Gumroad.IdGenerator do
  @moduledoc false

  @chars 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz0123456789'

  @doc """
  Generates a random string containing alphanumerical characters.

  ## Example

  Generate a string with the default length:

      > Gumroad.IdGenerator.generate()
      "ma73nMBby"

  Generate a string with a specified length:

      > Gumroad.IdGenerator.generate(20)
      "5BvT4RrbX8cW5ck1EHc3"
  """
  @spec generate(number()) :: String.t()
  def generate(length \\ 9) do
    for _ <- 1..length, into: "", do: <<Enum.random(@chars)>>
  end
end
