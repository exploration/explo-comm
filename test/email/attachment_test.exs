defmodule ExploComm.Email.AttachmentTest do
  use ExUnit.Case, async: true

  alias ExploComm.Email.Attachment

  test "create from file" do
    assert {:ok, attachment} = Attachment.from_file("./README.md")
    assert attachment.type == "text/markdown"
    assert attachment.name == "README.md"
  end
end
