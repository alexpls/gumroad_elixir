defmodule Gumroad do
  @external_resource readme = Path.join([__DIR__, "../README.md"])

  @moduledoc readme
             |> File.read!()
             |> String.split("<!-- MDOC -->")
             |> Enum.fetch!(1)

  @behaviour Gumroad.Client

  @doc """
  The Gumroad client to use.

  Setting the `:gumroad` `:client` config value will determine which client
  gets returned by this function.

  In production, this will be `Gumroad.Client.Live`, for testing this will
  likely be `Gumroad.Client.Mock`.
  """
  @spec client() :: Gumroad.Client
  def client do
    Application.get_env(:gumroad, :client, Gumroad.Client.Live)
  end

  def get_products() do
    client().get_products()
  end

  def get_resource_subscriptions(resource_name) when is_binary(resource_name) do
    client().get_resource_subscriptions(resource_name)
  end

  def create_resource_subscription(params) do
    client().create_resource_subscription(params)
  end

  def delete_resource_subscription(resource_subscription_id) do
    client().delete_resource_subscription(resource_subscription_id)
  end

  def get_subscribers(product_id) when is_binary(product_id) do
    client().get_subscribers(product_id)
  end

  def get_subscriber(subscriber_id) when is_binary(subscriber_id) do
    client().get_subscriber(subscriber_id)
  end

  def get_sale(sale_id) when is_binary(sale_id) do
    client().get_sale(sale_id)
  end

  def get_sales(params) do
    client().get_sales(params)
  end
end
