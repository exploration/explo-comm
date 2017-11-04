defmodule ExploComm.TwilioTest do
  use ExUnit.Case, async: true

  alias ExploComm.Twilio

  setup do
    {:ok, proper_number: "+16178675309"}
  end

  describe "formatting phone numbers" do 
    test "leaves a properly-formatted number alone",
        %{proper_number: proper_number} do
      assert ^proper_number = Twilio.format_phone(proper_number) 
    end

    test "prepends a + if there is no +", %{proper_number: proper_number} do
      number = "16178675309"
      assert ^proper_number = Twilio.format_phone(number) 
    end
    
    test "prepends a +1 and assumes domestic numbers if there is no + or 1",
        %{proper_number: proper_number} do
      number = "6178675309"
      assert ^proper_number = Twilio.format_phone(number) 
    end

    test "removes dots from a number", %{proper_number: proper_number} do
      number = "+1.617.867.5309"
      assert ^proper_number = Twilio.format_phone(number) 
    end

    test "removes dashes from a number", %{proper_number: proper_number} do
      number = "+1-617-867-5309"
      assert ^proper_number = Twilio.format_phone(number) 
    end

    test "removes parentheses from a number", %{proper_number: proper_number} do
      number = "+1(617)8675309"
      assert ^proper_number = Twilio.format_phone(number) 
    end

    test "removes spaces from a number", %{proper_number: proper_number} do
      number = "+1 617 8675309"
      assert ^proper_number = Twilio.format_phone(number) 
    end

    test "standard US format to proper format",
        %{proper_number: proper_number} do
      number = "(617) 867-5309"
      assert ^proper_number = Twilio.format_phone(number) 
    end
  end
end

