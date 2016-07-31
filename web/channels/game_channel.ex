defmodule Poketron.GameChannel do
  use Phoenix.Channel
  alias Poketron.Repo
  alias Poketron.Game

  def join("game:lobby", _params, socket) do
    {:ok, socket}
  end


  def join("game:" <> game_id, _params, socket) do
    game = Repo.get(Game, game_id)
    {:ok, assign(socket, :cid, game.container_id)}
  end

  def handle_in("start", _ , socket) do
    case socket.topic do
      "game:lobby" -> {:noreply, socket}
      _ ->
        pid = spawn timer(socket)
        {:noreply, socket}
    end
  end

  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end

  def timer(socket) do
    :timer.sleep(5000)
    do_log(socket, 5000)
    Poketron.GameChannel.timer(socket)
  end

  defp do_log(socket, since) do
    log = Dockerex.Client.get("containers/#{socket.assigns.cid}/logs?stderr=1&stdout=1&timestamps=0&since=#{DateTime.to_unix(DateTime.utc_now) - 5}")
    lines = case log do
              nil -> []
              log -> lines = String.split(log, "\r\n")
            end
    Enum.each(lines, fn(line) ->  __MODULE__.handle_out("new_msg", %{body: line}, socket) end )
  end
end
