defmodule Gumroad do
  @external_resource readme = Path.join([__DIR__, "../README.md"])

  @moduledoc readme
             |> File.read!()
             |> String.split("<!-- MDOC -->")
             |> Enum.fetch!(1)

  @behaviour Gumroad.Client

  @doc """
  The Gumroad client to use.

  Setting the `:gumroad_elixir` `:client` config value will determine which client
  gets returned by this function.

  In production, this will be `Gumroad.Client.Live`, for testing this will
  likely be `Gumroad.Client.Mock`.
  """
  @spec client() :: Gumroad.Client
  def client do
    Application.get_env(:gumroad_elixir, :client, Gumroad.Client.Live)
  end

  @spec get_products() :: {:ok, list(Gumroad.Product.t())} | {:error, Gumroad.Error.t()}
  def get_products() do
    client().get_products()
  end

  @spec get_resource_subscriptions(resource_name :: String.t()) ::
          {:ok, list(Gumroad.ResourceSubscription.t())} | {:error, Gumroad.Error.t()}
  def get_resource_subscriptions(resource_name) when is_binary(resource_name) do
    client().get_resource_subscriptions(resource_name)
  end

  @spec create_resource_subscription(params :: Gumroad.ResourceSubscription.create_params()) ::
          {:ok, Gumroad.ResourceSubscription.t()} | {:error, Gumroad.Error.t()}
  def create_resource_subscription(params) do
    client().create_resource_subscription(params)
  end

  @spec delete_resource_subscription(resource_subscription_id :: String.t()) ::
          {:ok} | {:error, Gumroad.Error.t()}
  def delete_resource_subscription(resource_subscription_id) do
    client().delete_resource_subscription(resource_subscription_id)
  end

  @spec get_subscribers(product_id :: String.t()) ::
          {:ok, list(Gumroad.Subscriber.t())} | {:error, Gumroad.Error.t()}
  def get_subscribers(product_id) when is_binary(product_id) do
    client().get_subscribers(product_id)
  end

  @spec get_subscriber(subscriber_id :: String.t()) ::
          {:ok, Gumroad.Subscriber.t()} | {:error, Gumroad.Error.t()}
  def get_subscriber(subscriber_id) when is_binary(subscriber_id) do
    client().get_subscriber(subscriber_id)
  end

  @spec get_sale(sale_id :: String.t()) ::
          {:ok, Gumroad.Sale.t()} | {:error, Gumroad.Error.t()}
  def get_sale(sale_id) when is_binary(sale_id) do
    client().get_sale(sale_id)
  end

  @spec get_sales(params :: Gumroad.Client.get_sales_params()) ::
          {:ok, list(Gumroad.Sale.t())} | {:error, Gumroad.Error.t()}
  def get_sales(params) do
    client().get_sales(params)
  end
end
