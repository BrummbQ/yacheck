defmodule Yacheck.Cart do
  use GenServer

  def init(state), do: {:ok, state}

  def handle_call({:scan, item}, _from, state) do
    {:reply, :ok, state ++ [item]}
  end

  def handle_call(:total, _from, state) do
    {:reply, 0, state}
  end

  ### Client Api

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def scan(item) do
    GenServer.call(__MODULE__, {:scan, item})
  end

  def total() do
    GenServer.call(__MODULE__, :total)
  end
end
