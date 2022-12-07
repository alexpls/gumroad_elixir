defmodule Gumroad.Error do
  @moduledoc """
  An error encountered while trying to query the Gumroad API.
  """
  defexception from_gumroad: false, reason: nil

  @typedoc """
  An error encountered while trying to query the Gumroad API.

  * `from_gumroad` - set to `true` if Gumroad was reached but
      returned an error while processing the request.
      Set to `false` if Gumroad could not be reached at all.
  * `reason` - set to the error message returned from Gumroad
      when `from_gumroad` is `true`. Otherwise is an atom
      pointing to the underlying error, i.e. `:timeout`.
  """
  @type t :: %__MODULE__{from_gumroad: boolean(), reason: any()}

  def message(%__MODULE__{from_gumroad: true, reason: reason}) do
    "Gumroad error: #{inspect(reason)}"
  end

  def message(%__MODULE__{reason: reason}), do: inspect(reason)
end
