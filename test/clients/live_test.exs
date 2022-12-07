defmodule Gumroad.Client.LiveTest do
  use Gumroad.LiveCase

  @moduledoc """
  Smoke test against a live Gumroad account.

  The suite currently assumes that you already have a product named
  "Test Product" in the Gumroad account that you're using for tests.

  TODO: Use the suite to seed a Gumroad account with resources so we
  can perform more meaningful assertions.
  """

  describe "products" do
    setup do
      {:ok, products} = Gumroad.get_products()
      product = Enum.find(products, fn p -> p.name == "Test Product" end)
      {:ok, product: product}
    end

    test "fetches products", %{product: product} do
      assert %Gumroad.Product{} = product
    end

    test "fetches subscribers", %{product: product} do
      {:ok, _} = Gumroad.get_subscribers(product.id)
    end
  end

  describe "subscribers" do
    test "fetching single subscriber fails when the subscriber doesn't exist" do
      {:error, %Gumroad.Error{from_gumroad: true, reason: "The subscriber was not found."}} =
        Gumroad.get_subscriber("not-a-real-subscriber!")
    end

    test "fetching a well-known subscriber" do
      # Hardcoded subscriber ID based on a well-known sub in my test Gumroad
      # environment. The sub had to be manually created because there
      # isn't a way to do it programatically.
      {:ok, _subscriber} = Gumroad.get_subscriber("OOcIqW2seScoGCn7rIAlMQ==")
    end
  end

  describe "sales" do
    test "fetching a sale fails when the sale does not exist" do
      {:error, %Gumroad.Error{from_gumroad: true, reason: "The sale was not found."}} =
        Gumroad.get_sale("not-a-real-sale!")
    end

    test "fetches a well-known sale" do
      # Hardcoded sale ID based on a well-known sale in my test Gumroad
      # environment. The sale had to be manually created because there
      # isn't a way to do it programatically.
      {:ok, _sale} = Gumroad.get_sale("uHg1486yFSKMlm5Z4Bg5DQ==")
    end

    test "fetches all sales" do
      {:ok, []} = Gumroad.get_sales(%{page: 1})
    end
  end

  describe "resource subscriptions" do
    test "create/fetch/delete resource subscriptions" do
      {:ok, new_resource_subscription} =
        Gumroad.create_resource_subscription(%{
          resource_name: "sale",
          post_url: "https://httpbin.org/post"
        })

      {:ok, resource_subscriptions} = Gumroad.get_resource_subscriptions("sale")

      assert %Gumroad.ResourceSubscription{} =
               Enum.find(resource_subscriptions, fn rs ->
                 rs.id == new_resource_subscription.id
               end)

      {:ok} = Gumroad.delete_resource_subscription(new_resource_subscription.id)
    end
  end
end
