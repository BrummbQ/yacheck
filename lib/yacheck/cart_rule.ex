defmodule Yacheck.CartRule do
  @callback configure(config :: term) ::
              (list -> {:ok, new_cart :: list} | {:error, new_cart :: list})
end

defmodule Yacheck.CartRule.BuyOneGetOneFree do
  @behaviour Yacheck.CartRule

  def configure(product_code) do
    fn cart -> transform(cart, product_code) end
  end

  defp transform(cart, product_code) do
    {_, cart} =
      Enum.reduce(cart, {0, []}, fn item, {index, items} ->
        if item.product_code == product_code do
          if rem(index, 2) != 0 do
            {index + 1, items ++ [%{item | price: Money.new(0, :GBP)}]}
          else
            {index + 1, items ++ [item]}
          end
        else
          {index, items ++ [item]}
        end
      end)

    {:ok, cart}
  end
end

defmodule Yacheck.CartRule.BulkDiscount do
  @behaviour Yacheck.CartRule

  def configure(config) do
    fn cart -> transform(cart, config) end
  end

  defp transform(cart, %{product_code: product_code, discounted_price: discounted_price}) do
    count = Enum.count(cart, fn item -> item.product_code == product_code end)

    new_cart =
      if count >= 3 do
        Enum.map(cart, fn item ->
          if item.product_code == product_code do
            %{item | price: discounted_price}
          else
            item
          end
        end)
      else
        cart
      end

    {:ok, new_cart}
  end
end

defmodule Yacheck.CartRule.BulkRelativeDiscount do
  @behaviour Yacheck.CartRule

  def configure(config) do
    fn cart -> transform(cart, config) end
  end

  defp transform(cart, %{product_code: product_code, discount: discount}) do
    count = Enum.count(cart, fn item -> item.product_code == product_code end)
    product = Enum.find(cart, fn item -> item.product_code == product_code end)

    new_cart =
      if count >= 3 do
        cart ++
          [
            %Yacheck.Product{
              product_code: product_code,
              name: "Discount",
              price: Money.multiply(product.price, 3) |> Money.multiply(discount) |> Money.neg()
            }
          ]
      else
        cart
      end

    {:ok, new_cart}
  end
end
