defmodule Gumroad.Client do
  @moduledoc """
  Defines a behaviour of a client that can be used for performing actions against
  a Gumroad implementation.

  Two implementations are provided:

  - `Gumroad.Client.Live` - Default client used in production. This one connects to
      the Gumroad API.
  - `Gumroad.Client.Mock` - Client to be used in tests. This returns canned responses
      _without_ making requests to the Gurmoad API.

  You can configure your application to use either of these implementation by setting
  the `:gumroad`, `:client` config property:

  ```elixir
  # In test mode, you'd probably want to use the Mock implementation
  # config/test.exs
  config :gumroad, :client, Gumroad.Client.Mock

  # In prod, you should use the Live implementation (which is the default)
  # config/prod.exs
  config :gumroad, :client, Gumroad.Client.Live
  ```
  """

  @doc """
  Retrieve all of the existing products.

  ## API

  When using `Gumroad.Client.Live`, this will call the Gumroad API at
  `GET /products`.
  """
  @callback get_products() :: {:ok, list(Gumroad.Product.t())} | {:error, Gumroad.Error.t()}

  @doc """
  Retrieve all active subscriptions for the given resource name.

  Valid resource names are:
  - `sale`
  - `refund`
  - `dispute`
  - `dispute_won`
  - `cancellation`
  - `subscription_updated`
  - `subscription_ended`
  - `subscription_restarted`

  ## API
  When using `Gumroad.Client.Live`, this will call the Gumroad API at
  `GET /resource_subscriptions`.
  """
  @callback get_resource_subscriptions(resource_name :: String.t()) ::
              {:ok, list(Gumroad.ResourceSubscription.t())} | {:error, Gumroad.Error.t()}

  @doc """
  Subscribe to a resource.

  Valid resource names are:

  - `sale`
  - `refund`
  - `dispute`
  - `dispute_won`
  - `cancellation`
  - `subscription_updated`
  - `subscription_ended`
  - `subscription_restarted`

  ## API
  When using `Gumroad.Client.Live`, this will call the Gumroad API at
  `PUT /resource_subscriptions`.
  """
  @callback create_resource_subscription(params :: Gumroad.ResourceSubscription.create_params()) ::
              {:ok, Gumroad.ResourceSubscription.t()} | {:error, Gumroad.Error.t()}

  @doc """
  Unsubscribe from a resource.

  ## API
  When using `Gumroad.Client.Live`, this will call the Gumroad API at
  `DELETE /resource_subscriptions/:resource_subscription_id`.
  """
  @callback delete_resource_subscription(resource_subscription_id :: String.t()) ::
              {:ok} | {:error, Gumroad.Error.t()}

  @doc """
  Retrieve the subscribers of the given product.

  ## API
  When using `Gumroad.Client.Live`, this will call the Gumroad API at
  `GET /products/:product_id/subcribers`.
  """
  @callback get_subscribers(product_id :: String.t()) ::
              {:ok, list(Gumroad.Subscriber.t())} | {:error, Gumroad.Error.t()}

  @doc """
  Retrieve a subscriber by their ID.

  ## API
  When using `Gumroad.Client.Live`, this will call the Gumroad API at
  `GET /subscribers/:id`.
  """
  @callback get_subscriber(subscriber_id :: String.t()) ::
              {:ok, Gumroad.Subscriber.t()} | {:error, Gumroad.Error.t()}

  @doc """
  Retrieve a sale by its ID.

  ## API
  When using `Gumroad.Client.Live`, this will call the Gumroad API at
  `GET /sales/:id`.
  """
  @callback get_sale(sale_id :: String.t()) ::
              {:ok, Gumroad.Sale.t()} | {:error, Gumroad.Error.t()}

  @type get_sales_params :: %{
          after: String.t() | nil,
          before: String.t() | nil,
          product_id: String.t() | nil,
          email: String.t() | nil,
          order_id: String.t() | nil,
          page: number()
        }

  @doc """
  Retrieves all of the successful sales by the authenticated user.

  ## Parameters
  * `after` (optional, date in form YYYY-MM-DD) - Only return sales after this date
  * `before` (optional, date in form YYYY-MM-DD) - Only return sales before this date
  * `product_id` (optional) - Filter sales by this product
  * `email` (optional) - Filter sales by this email
  * `order_id` (optional) - Filter sales by this Order ID
  * `page` (number) - Return this page of results

  ## API
  When using `Gumroad.Client.Live`, this will call the Gumroad API at
  `GET /sales`.
  """
  @callback get_sales(params :: get_sales_params()) ::
              {:ok, list(Gumroad.Sale.t())} | {:error, Gumroad.Error.t()}
end
