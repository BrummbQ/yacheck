defmodule Yacheck.CartTest do
  use ExUnit.Case

  alias Yacheck.CartRule.BuyOneGetOneFree
  alias Yacheck.Cart
  alias Yacheck.CartContainer
  alias Yacheck.Product

  test "scan item" do
    Cart.start_link()
    assert Cart.scan(Product.tea()) == :ok
    assert Cart.total() == "£3.11"
  end

  test "calculate total price for empty cart" do
    Cart.start_link()
    assert Cart.total() == "£0.00"
  end

  test "calculate total price for green tea" do
    Cart.start_link(%CartContainer{items: [Product.tea()], rules: []})
    assert Cart.total() == "£3.11"
  end

  test "calculate total price for green tea with rules" do
    Cart.start_link(%CartContainer{
      items: [Product.tea()],
      rules: [BuyOneGetOneFree.configure("GR1")]
    })

    assert Cart.total() == "£3.11"
  end

  test "basket 1" do
    Cart.start_link(%CartContainer{
      items: [
        Product.tea(),
        Product.strawberries(),
        Product.tea(),
        Product.tea(),
        Product.coffee()
      ],
      rules: Yacheck.rules()
    })

    assert Cart.total() == "£22.45"
  end

  test "basket 2" do
    Cart.start_link(%CartContainer{
      items: [
        Product.tea(),
        Product.tea()
      ],
      rules: Yacheck.rules()
    })

    assert Cart.total() == "£3.11"
  end

  test "basket 3" do
    Cart.start_link(%CartContainer{
      items: [
        Product.strawberries(),
        Product.strawberries(),
        Product.tea(),
        Product.strawberries()
      ],
      rules: Yacheck.rules()
    })

    assert Cart.total() == "£16.61"
  end

  test "basket 4" do
    Cart.start_link(%CartContainer{
      items: [
        Product.tea(),
        Product.coffee(),
        Product.strawberries(),
        Product.coffee(),
        Product.coffee()
      ],
      rules: Yacheck.rules()
    })

    # we have some rounding errors here 30.57 -> 30.58
    assert Cart.total() == "£30.58"
  end
end
