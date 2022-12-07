defmodule Gumroad.Subscriber do
  @moduledoc """
  A Gumroad subscriber.

  See the [Gumroad docs](https://app.gumroad.com/api#subscribers) for more info.
  """
  @type t :: %__MODULE__{
          id: String.t(),
          product_id: String.t(),
          product_name: String.t(),
          user_id: String.t(),
          user_email: String.t(),
          purchase_ids: list(String.t()),
          created_at: String.t(),
          user_requested_cancellation_at: nil,
          charge_occurrence_count: nil,
          recurrence: String.t(),
          cancelled_at: nil,
          ended_at: nil,
          failed_at: nil,
          free_trial_ends_at: nil,
          license_key: String.t(),
          status: String.t()
        }

  defstruct [
    :id,
    :product_id,
    :product_name,
    :user_id,
    :user_email,
    :purchase_ids,
    :created_at,
    :user_requested_cancellation_at,
    :charge_occurrence_count,
    :recurrence,
    :cancelled_at,
    :ended_at,
    :failed_at,
    :free_trial_ends_at,
    :license_key,
    :status
  ]

  def new(body) do
    %__MODULE__{
      id: Map.fetch!(body, "id"),
      product_id: Map.get(body, "product_id"),
      product_name: Map.get(body, "product_name"),
      user_id: Map.get(body, "user_id"),
      user_email: Map.get(body, "user_email"),
      purchase_ids: Map.get(body, "purchase_ids"),
      created_at: Map.get(body, "created_at"),
      user_requested_cancellation_at: Map.get(body, "user_requested_cancellation_at"),
      charge_occurrence_count: Map.get(body, "charge_occurrence_count"),
      recurrence: Map.get(body, "recurrence"),
      cancelled_at: Map.get(body, "cancelled_at"),
      ended_at: Map.get(body, "ended_at"),
      failed_at: Map.get(body, "failed_at"),
      free_trial_ends_at: Map.get(body, "free_trial_ends_at"),
      license_key: Map.get(body, "license_key"),
      status: Map.get(body, "status")
    }
  end
end
