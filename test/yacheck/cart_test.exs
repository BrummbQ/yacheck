defmodule Yacheck.CartTest do
  use ExUnit.Case
  alias Yacheck.Cart
  alias Yacheck.Product

  setup do
    {:ok, p: Cart.start_link()}
  end

  test "scan item" do
    [product | _] = Product.available_products()
    assert Cart.scan(product) == :ok
  end

  test "calculate total price" do
    assert Cart.total() == 0
  end
end
