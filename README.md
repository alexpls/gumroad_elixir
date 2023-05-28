# gumroad_elixir

[![Hex.pm](https://img.shields.io/hexpm/v/gumroad_elixir)](https://hex.pm/packages/gumroad_elixir) [![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg)](https://hexdocs.pm/gumroad_elixir) ![.github/workflows/ci.yml](https://github.com/alexpls/gumroad_elixir/actions/workflows/ci.yml/badge.svg)

<!-- MDOC -->

An unofficial [Gumroad](https://gumroad.com) API client for Elixir applications.

---

**⚠️ Pay heed!** This package does not yet implement the complete Gumroad API.
See the "Incomplete implementation" section below for more details.

---

## Documentation

Full documentation available on [HexDocs](https://hexdocs.pm/gumroad_elixir/Gumroad.html).

## Usage

```elixir
iex> {:ok, products} = Gumroad.get_products()
iex> products
[%Gumroad.Product{id: "...", name: "..."}, %Gumroad.Product{id: "...", name: "..."}]

iex> {:ok, subscribers} = Gumroad.get_subscribers(List.first(products).id)
iex> subscribers
[%Gumroad.Subscriber{id: "...", status: "alive"}]
```

## Installation

Add `gumroad_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gumroad_elixir, "~> 0.1.0"}
  ]
end
```

Then, configure your [Gumroad access token](https://help.gumroad.com/article/280-create-application-api):

```elixir
# config.exs
config :gumroad_elixir, :access_token, "your-gumroad-access-token"
```

## Configuration

Configuration properties on the `:gumroad_elixir` application are:

- `:access_token` (required) - The access token used to authenticate to the Gumroad API.
  _(For details on how to create an access token, see [Gumroad docs](https://help.gumroad.com/article/280-create-application-api))._

- `:client` (defaults to `Gumroad.Client.Live`) - The client implementation to use when handling API
  operations. Used for switching between a mock client and one that makes requests against
  the live Gumroad API. More details on the [`Gumroad.Client` docs](https://hexdocs.pm/gumroad_elixir/Gumroad.Client.html).

## Error handling

Error messages sent by Gumroad's API in response to failed requests
are propagated as-is to your application, with the `from_gumroad` property
set to `true`:

```elixir
iex> Gumroad.get_sale("not-a-real-sale")
{:error, %Gumroad.Error{from_gumroad: true, reason: "The sale was not found."}}
```

Errors caused by other reasons (like network timeouts) have the `from_gumroad`
property set to `false`:

```elixir
# Disconnect wi-fi, and...
iex> Gumroad.Client.get_sale("not-a-real-sale")
{:error, %Gumroad.Error{from_gumroad: false, reason: :timeout}}
```

## Authentication

An access token is included as a parameter on each request made to the Gumroad API.

To create an access token, see [Gumroad's docs](https://help.gumroad.com/article/280-create-application-api).

## Testing

Gumroad doesn't currently offer a native solution for local development or testing.
To make up for this, this package includes local dev and testing mocks which ensure that
you don't have to make calls to the live Gumroad API from non-prod environments.

To use mock responses, set `:gumroad_elixir` `:client` to `Gumroad.Client.Mock` (more details on
the [`Gumroad.Client docs`](https://hexdocs.pm/gumroad_elixir/Gumroad.Client.html)).

Now when you perform an action that would create a request against the Gumroad API, you'll get a
mocked response instead:

```elixir
iex> Gumroad.get_resource_subscriptions("abc")
{:ok,
 %Gumroad.ResourceSubscription{
   id: "test-resource-subscription-id",
   post_url: "http://example.org",
   resource_name: "abc"
 }}
```

## Incomplete implementation

This package does not implement the entire Gumroad API.
I extracted it out of a project ([Mailgrip](https://mailgrip.io)) where
I only implemented support for the endpoints I needed.

An overall framework has been created though, with the intention of making
addition of new endpoints straightforward.

If you'd like support for a new endpoint, I'd love for you to open a PR (my preference!)
or otherwise open an issue and I can look into adding support.

### What API endpoints are implemented?

The following table tracks all endpoints currently available on the [Gumroad API](https://app.gumroad.com/api)
and whether they've been implemented in this package.

| Gumroad API                                                                         | Implemented? |
| ----------------------------------------------------------------------------------- | ------------ |
| `GET /products`                                                                     | ✅           |
| `GET /products/:product_id/subscribers`                                             | ✅           |
| `PUT /resource_subscriptions`                                                       | ✅           |
| `GET /resource_subscriptions`                                                       | ✅           |
| `DELETE /resource_subscriptions/:resource_subscription_id`                          | ✅           |
| `GET /sales/:id`                                                                    | ✅           |
| `GET /subscribers/:id`                                                              | ✅           |
| `GET /sales`                                                                        | ✅           |
| `GET /products/:id`                                                                 | ✅           |
| `DELETE /products/:id`                                                              | ❌           |
| `PUT /products/:id/enable`                                                          | ❌           |
| `PUT /products/:id/disable`                                                         | ❌           |
| `POST /products/:product_id/variant_categories`                                     | ❌           |
| `GET /products/:product_id/variant_categories/:id`                                  | ❌           |
| `PUT /products/:product_id/variant_categories/:id`                                  | ❌           |
| `DELETE /products/:product_id/variant_categories/:id`                               | ❌           |
| `GET /products/:product_id/variant_categories`                                      | ❌           |
| `POST /products/:product_id/variant_categories/:variant_category_id/variants`       | ❌           |
| `GET /products/:product_id/variant_categories/:variant_category_id/variants/:id`    | ❌           |
| `PUT /products/:product_id/variant_categories/:variant_category_id/variants/:id`    | ❌           |
| `DELETE /products/:product_id/variant_categories/:variant_category_id/variants/:id` | ❌           |
| `GET /products/:product_id/variant_categories/:variant_category_id/variants`        | ❌           |
| `GET /products/:product_id/offer_codes`                                             | ❌           |
| `GET /products/:product_id/offer_codes/:id`                                         | ❌           |
| `POST /products/:product_id/offer_codes`                                            | ❌           |
| `PUT /products/:product_id/offer_codes/:id`                                         | ❌           |
| `DELETE /products/:product_id/offer_codes/:id`                                      | ❌           |
| `GET /products/:product_id/custom_fields`                                           | ❌           |
| `POST /products/:product_id/custom_fields`                                          | ❌           |
| `PUT /products/:product_id/custom_fields/:name`                                     | ❌           |
| `DELETE /products/:product_id/custom_fields/:name`                                  | ❌           |
| `GET /user`                                                                         | ❌           |
| `PUT /sales/:id/mark_as_shipped`                                                    | ❌           |
| `PUT /sales/:id/refund`                                                             | ❌           |
| `POST /licenses/verify`                                                             | ❌           |
| `PUT /licenses/enable`                                                              | ❌           |
| `PUT /licenses/disable`                                                             | ❌           |
| `PUT /licenses/decrement_uses_count`                                                | ❌           |

### What else needs to be done?

Besides supporting all API endpoints, there are a few other
areas I'd like to tackle before calling this client "production
ready":

- Retry mechanism in case an API request fails.
- Telemetry.
- Consider moving off of HTTPoison dependency and onto native httpc.
