defmodule Yacheck.CartTest do
  use ExUnit.Case
  alias Yacheck.Cart

  setup do
    {:ok, p: Cart.start_link()}
  end

  test "scan item" do
    assert Cart.scan("banana") == :ok
  end

  test "calculate total price" do
    assert Cart.total() == 0
  end
end
