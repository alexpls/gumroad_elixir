defmodule Gumroad.Client.Live do
  @moduledoc false

  use HTTPoison.Base
  alias Gumroad.{Sale, Subscriber, ResourceSubscription, Product}

  @behaviour Gumroad.Client

  @endpoint "https://api.gumroad.com/v2"
  @default_headers [{"User-Agent", "gumroad-elixir https://github.com/alexpls/gumroad_elixir"}]

  @impl Gumroad.Client
  def get_products() do
    get("/products")
    |> parse_error()
    |> case do
      {:ok, %{body: %{"products" => products}}} ->
        {:ok, Enum.map(products, &Product.new/1)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl Gumroad.Client
  def get_resource_subscriptions(resource_name) when is_binary(resource_name) do
    "/resource_subscriptions"
    |> add_query_param(%{"resource_name" => resource_name})
    |> get()
    |> parse_error()
    |> case do
      {:ok, %{body: %{"resource_subscriptions" => resource_subscriptions}}} ->
        {:ok, Enum.map(resource_subscriptions, &ResourceSubscription.new/1)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl Gumroad.Client
  def create_resource_subscription(params) do
    "/resource_subscriptions"
    |> add_query_param(params)
    |> put()
    |> parse_error()
    |> case do
      {:ok, %{body: %{"resource_subscription" => resource_subscription}}} ->
        {:ok, ResourceSubscription.new(resource_subscription)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl Gumroad.Client
  def delete_resource_subscription(resource_subscription_id) do
    "/resource_subscriptions/#{resource_subscription_id}"
    |> delete()
    |> parse_error()
    |> case do
      {:ok, %{}} -> {:ok}
      {:error, reason} -> {:error, reason}
    end
  end

  @impl Gumroad.Client
  def get_subscribers(product_id) when is_binary(product_id) do
    get("/products/#{product_id}/subscribers")
    |> parse_error()
    |> case do
      {:ok, %{body: %{"subscribers" => subscribers}}} ->
        {:ok, Enum.map(subscribers, &Subscriber.new/1)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl Gumroad.Client
  def get_subscriber(subscriber_id) when is_binary(subscriber_id) do
    get("/subscribers/#{subscriber_id}")
    |> parse_error()
    |> case do
      {:ok, %{body: %{"subscriber" => subscriber}}} ->
        {:ok, Subscriber.new(subscriber)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl Gumroad.Client
  def get_sale(sale_id) when is_binary(sale_id) do
    get("/sales/#{sale_id}")
    |> parse_error()
    |> case do
      {:ok, %{body: %{"sale" => sale}}} ->
        {:ok, Sale.new(sale)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl Gumroad.Client
  def get_sales(params) do
    "/sales"
    |> add_query_param(params)
    |> get()
    |> parse_error()
    |> case do
      {:ok, %{body: %{"sales" => sales}}} ->
        {:ok, Enum.map(sales, &Sale.new/1)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_error({:ok, %{body: %{"success" => success}} = response}) when success == true,
    do: {:ok, response}

  defp parse_error({:ok, %{body: %{"success" => success, "message" => message}}})
       when success == false,
       do: {:error, %Gumroad.Error{from_gumroad: true, reason: message}}

  defp parse_error({:error, %HTTPoison.Error{reason: reason}}),
    do: {:error, %Gumroad.Error{from_gumroad: false, reason: reason}}

  @impl true
  def process_response_body(body) do
    Jason.decode!(body)
  end

  @impl true
  def process_url(url) do
    URI.parse(@endpoint <> url)
    |> add_query_param(%{"access_token" => access_token()})
    |> URI.to_string()
  end

  @impl true
  def process_request_headers(headers) do
    @default_headers ++ headers
  end

  defp add_query_param(url, query_param_map) when is_binary(url) do
    URI.parse(url)
    |> add_query_param(query_param_map)
    |> URI.to_string()
  end

  defp add_query_param(%URI{} = url, query_param_map) do
    url
    |> Map.update(:query, URI.encode_query(query_param_map), fn existing ->
      case existing do
        nil ->
          query_param_map
          |> URI.encode_query()

        existing ->
          URI.decode_query(existing)
          |> Map.merge(query_param_map)
          |> URI.encode_query()
      end
    end)
  end

  defp access_token do
    Application.fetch_env!(:gumroad_elixir, :access_token)
  end
end
