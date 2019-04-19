defmodule Yacheck.ProductTest do
  use ExUnit.Case
  alias Yacheck.Product

  test "create product" do
    product = %Product{product_code: "code", name: "name", price: Money.new(100, :GBP)}
    assert product.product_code == "code"
    assert product.name == "name"
    assert product.price == Money.new(100, :GBP)
  end
end
