defmodule DemoCore do
  def schema do
    quote do
      use Ecto.Schema

      @timestamps_opts [type: :naive_datetime_usec]
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
