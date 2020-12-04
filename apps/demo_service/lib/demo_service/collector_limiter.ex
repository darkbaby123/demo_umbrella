defmodule DemoService.CollectorLimiter do
  @moduledoc """
  例子：

      iex> collector_id = 1

      iex> DemoService.CollectorLimiter.start_limiter(collector_id)
      {:ok, #PID<0.123.0>}

      iex> DemoService.CollectorLimiter.incr_count(collector_id)
      {:ok, 35} # return current amount

      iex> DemoService.CollectorLimiter.stop_limiter(collector_id)
      :ok

  """
  use Supervisor

  @registry DemoService.CollectorLimiter.Registry
  @supervisor DemoService.CollectorLimiter.Supervisor
  @worker DemoService.CollectorLimiter.Worker

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Registry, keys: :unique, name: @registry},
      %{
        id: @supervisor,
        start: {DynamicSupervisor, :start_link, [[strategy: :one_for_one, name: @supervisor]]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec start_limiter(collector_id :: integer) :: {:ok, pid} | {:error, :limiter_already_started}
  def start_limiter(collector_id) do
    child_spec = %{
      id: @worker,
      start:
        {@worker, :start_link,
         [
           [collector_id: collector_id],
           [name: limiter_name(collector_id)]
         ]},
      restart: :transient
    }

    case DynamicSupervisor.start_child(@supervisor, child_spec) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, _pid}} -> {:error, :limiter_already_started}
    end
  end

  @spec stop_limiter(collector_id :: integer) ::
          {:ok, pid} | {:error, :limiter_not_started | :not_found}
  def stop_limiter(collector_id) do
    with {:ok, pid} <- find_limiter_pid(collector_id),
         :ok <- DynamicSupervisor.terminate_child(@supervisor, pid) do
      {:ok, pid}
    end
  end

  @spec incr_count(collector_id :: integer) :: {:ok, integer} | {:error, :collector_full}
  def incr_count(collector_id) do
    GenServer.call(limiter_name(collector_id), :incr_count)
  end

  defp limiter_name(collector_id) do
    {:via, Registry, {@registry, collector_id}}
  end

  defp find_limiter_pid(collector_id) do
    case Registry.lookup(@registry, collector_id) do
      [{pid, _}] -> {:ok, pid}
      [] -> {:error, :limiter_not_started}
    end
  end
end
