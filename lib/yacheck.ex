defmodule Yacheck do
  alias Yacheck.CartRule.BulkDiscount
  alias Yacheck.CartRule.BulkRelativeDiscount
  alias Yacheck.CartRule.BuyOneGetOneFree

  def rules do
    [
      BuyOneGetOneFree.configure("GR1"),
      BulkDiscount.configure(%{product_code: "SR1", discounted_price: Money.new(450, :GBP)}),
      BulkRelativeDiscount.configure(%{product_code: "CF1", discount: 1 / 3})
    ]
  end
end
