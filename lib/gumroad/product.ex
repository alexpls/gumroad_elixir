defmodule Gumroad.Product do
  @moduledoc """
  A Gumroad product.

  See the [Gumroad docs](https://app.gumroad.com/api#products) for more info.
  """
  @type variant_option :: %{
          name: String.t(),
          price_difference: number(),
          is_pay_what_you_want: boolean(),
          recurrence_prices: %{
            optional(any) => %{
              price_cents: number(),
              suggested_price_cents: number()
            }
          }
        }

  @type variant :: %{
          title: String.t(),
          options: list(variant_option())
        }

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          custom_permalink: String.t() | nil,
          custom_receipt: String.t() | nil,
          custom_summary: String.t(),
          custom_fields: list(),
          customizable_price: String.t() | nil,
          description: String.t(),
          deleted: boolean(),
          max_purchase_count: integer() | nil,
          preview_url: String.t() | nil,
          require_shipping: boolean(),
          subscription_duration: String.t() | nil,
          published: boolean(),
          url: String.t(),
          price: number(),
          currency: String.t(),
          short_url: String.t(),
          thumbnail_url: String.t(),
          tags: list(String.t()),
          formatted_price: String.t(),
          file_info: map(),
          shown_on_profile: boolean(),
          sales_count: number(),
          sales_usd_cents: number(),
          is_tiered_membership: boolean(),
          recurrences: [String.t()],
          variants: list(variant())
        }

  defstruct [
    :id,
    :name,
    :custom_permalink,
    :custom_receipt,
    :custom_summary,
    :custom_fields,
    :customizable_price,
    :description,
    :deleted,
    :max_purchase_count,
    :preview_url,
    :require_shipping,
    :subscription_duration,
    :published,
    :url,
    :price,
    :currency,
    :short_url,
    :thumbnail_url,
    :tags,
    :formatted_price,
    :file_info,
    :shown_on_profile,
    :sales_count,
    :sales_usd_cents,
    :is_tiered_membership,
    :recurrences,
    :variants
  ]

  def new(body) do
    %__MODULE__{
      id: Map.fetch!(body, "id"),
      name: Map.get(body, "name"),
      custom_permalink: Map.get(body, "custom_permalink"),
      custom_receipt: Map.get(body, "custom_receipt"),
      custom_summary: Map.get(body, "custom_summary"),
      custom_fields: Map.get(body, "custom_fields"),
      customizable_price: Map.get(body, "customizable_price"),
      description: Map.get(body, "description"),
      deleted: Map.get(body, "deleted"),
      max_purchase_count: Map.get(body, "max_purchase_count"),
      preview_url: Map.get(body, "preview_url"),
      require_shipping: Map.get(body, "require_shipping"),
      subscription_duration: Map.get(body, "subscription_duration"),
      published: Map.get(body, "published"),
      url: Map.get(body, "url"),
      price: Map.get(body, "price"),
      currency: Map.get(body, "currency"),
      short_url: Map.get(body, "short_url"),
      thumbnail_url: Map.get(body, "thumbnail_url"),
      tags: Map.get(body, "tags"),
      formatted_price: Map.get(body, "formatted_price"),
      file_info: Map.get(body, "file_info"),
      shown_on_profile: Map.get(body, "shown_on_profile"),
      sales_count: Map.get(body, "sales_count"),
      sales_usd_cents: Map.get(body, "sales_usd_cents"),
      is_tiered_membership: Map.get(body, "is_tiered_membership"),
      recurrences: Map.get(body, "recurrences"),
      variants:
        Map.get(body, "variants")
        |> case do
          nil -> nil
          variants -> Enum.map(variants, &parse_variant/1)
        end
    }
  end

  @spec parse_variant(body :: any()) :: variant()
  defp parse_variant(body) do
    %{
      title: Map.get(body, "title"),
      options:
        Map.get(body, "options")
        |> case do
          nil -> nil
          options -> Enum.map(options, &parse_variant_options/1)
        end
    }
  end

  @spec parse_variant_options(body :: any()) :: variant_option()
  defp parse_variant_options(body) do
    %{
      name: Map.get(body, "name"),
      price_difference: Map.get(body, "price_difference"),
      is_pay_what_you_want: Map.get(body, "is_pay_what_you_want"),
      recurrence_prices:
        Map.get(body, "recurrence_prices")
        |> case do
          nil ->
            nil

          other ->
            Enum.reduce(other, %{}, fn {key, value}, acc ->
              Map.put(acc, key, %{
                price_cents: Map.get(value, "price_cents"),
                suggested_price_cents: Map.get(value, "suggested_price_cents")
              })
            end)
        end
    }
  end
end
