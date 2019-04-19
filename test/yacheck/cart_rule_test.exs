defmodule Yacheck.CartRuleTest do
  use ExUnit.Case

  alias Yacheck.CartRule.BuyOneGetOneFree
  alias Yacheck.CartRule.BulkDiscount
  alias Yacheck.CartRule.BulkRelativeDiscount
  alias Yacheck.Product

  test "get free item" do
    tea = Product.tea()

    transform = BuyOneGetOneFree.configure("GR1")
    assert transform.([tea]) == {:ok, [tea]}
    assert transform.([tea, tea]) == {:ok, [tea, %{tea | price: Money.new(0, :GBP)}]}
  end

  test "get bulk discount" do
    tea = Product.tea()
    discount_tea = %{tea | price: Money.new(150, :GBP)}

    transform =
      BulkDiscount.configure(%{product_code: "GR1", discounted_price: Money.new(150, :GBP)})

    assert transform.([tea, tea, tea]) == {:ok, [discount_tea, discount_tea, discount_tea]}
  end

  test "get bulk relative discount" do
    tea = %Product{product_code: "GR1", name: "Green tea", price: Money.new(100, :GBP)}
    discount_tea = %{tea | price: Money.new(50, :GBP)}

    transform = BulkRelativeDiscount.configure(%{product_code: "GR1", discount: 0.5})

    assert transform.([tea, tea, tea]) == {:ok, [discount_tea, discount_tea, discount_tea]}
  end
end
