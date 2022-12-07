defmodule Gumroad.Client.Mock do
  @moduledoc false

  import Gumroad.Testing.Fixtures

  @behaviour Gumroad.Client

  @impl Gumroad.Client
  def get_products() do
    {:ok, [product()]}
  end

  @impl Gumroad.Client
  def get_resource_subscriptions(resource_name) when is_binary(resource_name) do
    {:ok, [resource_subscription(%{resource_name: resource_name})]}
  end

  @impl Gumroad.Client
  def create_resource_subscription(params) do
    {:ok, resource_subscription(params)}
  end

  @impl Gumroad.Client
  def delete_resource_subscription(_id) do
    {:ok}
  end

  @impl Gumroad.Client
  def get_subscribers(product_id) when is_binary(product_id) do
    {:ok, [subscriber()]}
  end

  @impl Gumroad.Client
  def get_subscriber(subscriber_id) when is_binary(subscriber_id) do
    {:ok, subscriber(%{id: subscriber_id})}
  end

  @impl Gumroad.Client
  def get_sale(sale_id) when is_binary(sale_id) do
    {:ok, sale(%{id: sale_id})}
  end

  @impl Gumroad.Client
  def get_sales(_params) do
    {:ok, [sale(), sale()]}
  end
end
