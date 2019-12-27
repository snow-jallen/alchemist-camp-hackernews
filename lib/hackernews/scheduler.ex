defmodule Hackernews.Scheduler do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    handle_info(:work, state)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Hackernews.run()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self() ,:work, 1_000 * 60 * 5 )
  end

end
