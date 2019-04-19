defmodule Yacheck.CartContainer do
  defstruct items: [], rules: []
end

defmodule Yacheck.Cart do
  @moduledoc """
  Main Cart process. Can be configured with start items and rules
  """
  use GenServer

  def init(state), do: {:ok, state}

  def handle_call({:scan, item}, _from, state) do
    {:reply, :ok, %{state | items: state.items ++ [item]}}
  end

  def handle_call(:total, _from, state) do
    new_items =
      Enum.reduce(state.rules, state.items, fn rule, items ->
        case rule.(items) do
          {:error, _} -> items
          {:ok, new_items} -> new_items
        end
      end)

    {:reply, sum_prices(new_items) |> Money.to_string(), state}
  end

  defp sum_prices(items) do
    Enum.reduce(items, Money.new(0, :GBP), fn item, acc ->
      Money.add(item.price, acc)
    end)
  end

  ### Client Api

  def start_link(state \\ %Yacheck.CartContainer{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def scan(item) do
    GenServer.call(__MODULE__, {:scan, item})
  end

  def total() do
    GenServer.call(__MODULE__, :total)
  end
end
