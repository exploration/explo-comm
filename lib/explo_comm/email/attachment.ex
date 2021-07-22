defmodule ExploComm.Email.Attachment do
  @moduledoc """
  A data shape for email attachments

  ## Examples

      %ExploComm.Email.Attachment{type: "image/png", name: "SomeImage.png", content: "base64-encoded-image-data"}
  """
  @typedoc """
  An email attachment
  """
  @type t :: %__MODULE__{
          content: String.t(),
          name: String.t(),
          type: String.t()
        }

  @enforce_keys [:content, :name, :type]
  defstruct [:content, :name, :type]

  @doc """
  Create an attachment from a file.
  """
  @spec from_file(String.t()) :: {:ok, t()} | {:error, term()}
  def from_file(path) do
    with {:ok, contents} <- File.read(path),
         encoded_contents <- Base.encode64(contents),
         name <- Path.basename(path),
         type <- MIME.from_path(path) do
      {:ok, %__MODULE__{
        content: encoded_contents,
        name: name,
        type: type
      }}
    else
      error ->
        {:error, error}
    end
  end
end
