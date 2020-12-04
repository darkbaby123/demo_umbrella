defmodule DemoService.CollectorLimiter.Worker do
  @moduledoc """
  例子：

      iex> {:ok, pid} = GenServer.start_link(
      ...>   DemoService.CollectorLimiter.Worker,
      ...>   [collector_id: 1]
      ...> )
      {:ok, #PID<0.123.0>}

      iex> GenServer.call(pid, :incr_count)
      {:ok, 1}

      iex> GenServer.stop(pid)
      {:ok}

  """
  use GenServer

  alias DemoService.Collectors

  defmodule State do
    defstruct id: nil, curr_amount: nil, amount: nil, persisted?: true
  end

  @persist_interval 5_000

  def start_link(init_arg, opts \\ []) do
    GenServer.start_link(__MODULE__, init_arg, opts)
  end

  @impl true
  def init(opts) do
    collector_id = Keyword.fetch!(opts, :collector_id)

    collector = Collectors.get_collector!(collector_id)
    state = %State{id: collector.id, curr_amount: collector.curr_amount, amount: collector.amount}

    Process.flag(:trap_exit, true)
    send_delay_persist()

    {:ok, state}
  end

  @impl true
  def handle_call(:incr_count, _from, %State{curr_amount: curr_amount, amount: amount} = state)
      when curr_amount < amount do
    new_curr_amount = curr_amount + 1
    new_state = %{state | curr_amount: new_curr_amount, persisted?: false}
    {:reply, {:ok, new_curr_amount}, new_state}
  end

  @impl true
  def handle_call(:incr_count, _from, state) do
    {:reply, {:error, :collector_full}, state}
  end

  @impl true
  def handle_info(:persist, state) do
    send_delay_persist()
    {:noreply, persist(state)}
  end

  defp send_delay_persist do
    Process.send_after(self(), :persist, @persist_interval)
  end

  defp persist(%State{id: id, curr_amount: curr_amount, persisted?: false} = state) do
    Collectors.update_curr_amount(id, curr_amount)
    %{state | persisted?: true}
  end

  defp persist(state), do: state
end
