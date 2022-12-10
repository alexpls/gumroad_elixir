defmodule Gumroad.LiveCase do
  @moduledoc """
  A test case to be included when you want to test against the Live
  Gumroad API.

  ## Example

  ```elixir
  defmodule Gumroad.MyTest do
    use Gumroad.LiveCase
  end
  ```
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @moduletag :live
    end
  end

  setup do
    Application.put_env(:gumroad_elixir, :client, Gumroad.Client.Live)

    Application.put_env(
      :gumroad_elixir,
      :access_token,
      System.fetch_env!("GUMROAD_TEST_ACCESS_TOKEN")
    )

    on_exit(fn -> Application.put_env(:gumroad_elixir, :client, Gumroad.Client.Mock) end)
  end
end
