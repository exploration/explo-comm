defmodule ExploComm.Email.Recipient do
  @moduledoc """
  A data shape for email recipients

  ## Examples

      %ExploComm.Email.Recipient{type: "cc", name: "Iggy Azalea", email: "iggy@explo.org"}
  """
  @typedoc """
  An email recipient
  """
  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t(),
          type: String.t()
        }

  @enforce_keys [:email]
  defstruct [:name, :email, type: "to"]
end
