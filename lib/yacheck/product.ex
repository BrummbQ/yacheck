defmodule Yacheck.Product do
  @moduledoc """
  Contains product for a cart
  """
  alias __MODULE__

  @enforce_keys [:product_code, :name, :price]
  defstruct product_code: nil, name: nil, price: nil

  def available_products do
    [
      %Product{product_code: "GR1", name: "Green tea", price: Money.new(311, :GBP)},
      %Product{product_code: "SR1", name: "Strawberries", price: Money.new(500, :GBP)},
      %Product{product_code: "CF1", name: "Coffee", price: Money.new(1123, :GBP)}
    ]
  end
end
