defmodule Gumroad.ResourceSubscription do
  @moduledoc """
  A Gumroad resource subscription.

  See the [Gumroad docs](https://app.gumroad.com/api#resource-subscriptions) for more info.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          resource_name: String.t(),
          post_url: String.t()
        }

  @type create_params :: %{
          resource_name: String.t(),
          post_url: String.t()
        }

  defstruct [:id, :resource_name, :post_url]

  def new(body) do
    %__MODULE__{
      id: Map.fetch!(body, "id"),
      resource_name: Map.fetch!(body, "resource_name"),
      post_url: Map.fetch!(body, "post_url")
    }
  end
end
