defmodule Gumroad.Testing.Fixtures do
  @moduledoc """
  Provides fixtures that can be used with a mock
  Gumroad API client implementation, to simulate a
  response from Gumroad.

  See `Gumroad.Client` for more info about the `Mock`
  client.
  """

  alias Gumroad.{Sale, Subscriber, ResourceSubscription, Product, IdGenerator}

  @spec product() :: Product.t()
  def product() do
    %Product{id: "test-product-id", name: "My test product"}
  end

  @spec resource_subscription(map()) :: ResourceSubscription.t()
  def resource_subscription(attrs \\ %{}) do
    struct(
      %ResourceSubscription{
        id: "test-resource-subscription-id",
        resource_name: "sale",
        post_url: "http://example.org"
      },
      attrs
    )
  end

  @spec subscriber(map()) :: Subscriber.t()
  def subscriber(attrs \\ %{}) do
    struct(
      %Subscriber{
        id: "test-subscriber-id",
        status: "alive",
        free_trial_ends_at: nil
      },
      attrs
    )
  end

  @spec sale(map()) :: Sale.t()
  def sale(attrs \\ %{}) do
    struct(
      %Sale{
        id: "test-sale-id",
        subscription_duration: "1 month",
        product_id: "test-product-id",
        purchaser_id: "test-purchaser-id",
        purchase_email: "hey@example.org",
        subscription_id: "test-subscription-id-#{IdGenerator.generate()}",
        cancelled: false,
        ended: false,
        recurring_charge: true,
        quantity: 1
      },
      attrs
    )
  end
end
