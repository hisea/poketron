defmodule Poketron.GameController do
  use Poketron.Web, :controller
  import Ecto.Changeset, only: [put_change: 3]
 
  plug Guardian.Plug.EnsureAuthenticated, handler: Poketron.AuthHandler
  plug Poketron.Plug.AssignUser

  alias Poketron.Game
  alias Poketron.Repo
  require IEx

  def index(conn, _params) do
    user = conn.assigns.user
    games = Game
    |> Game.for_user(user)
    |> Game.running
    |> Repo.all

    render conn, "index.html", games: games
  end

  def new(conn, _params) do
    changeset = Game.changeset(%Game{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, params) do
    user = conn.assigns.user
    result = run_docker(params["game"]["account"],
      params["game"]["username"],
      params["game"]["password"],
      params["game"]["location"])

    case result do
      %{"Id" => cid} ->
        changeset = Game.changeset(%Game{user_id: user.id, container_id: cid}, %{})
        changeset
        |> put_change(:container_id, cid)
        |> Repo.insert

        conn
        |> put_flash(:info, "Created Game")
        |> redirect(to: game_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Cannot start bot at this time")
        |> redirect(to: game_path(conn, :index))


    end
    render conn, "new.html", changeset: changeset
  end

  def show(conn, params) do
    game = Game
    |> Game.by_cid(params["id"])
    |> Repo.one

    render conn, "show.html", game: game
  end

  def stop(conn, params) do
    game = Repo.get(Game, params["id"])

    stop_docker(game.container_id)

    c = Game.changeset(game, %{status: "Deleted", deleted_at: Ecto.DateTime.utc})
    Repo.update(c)

    conn
    |> put_flash(:info, "Stopped Game")
    |> redirect(to: game_path(conn, :index))
  end

  def destroy(conn, params) do
    
  end

  defp stop_docker(cid) do
    Dockerex.Client.post("containers/#{cid}/stop")
    Dockerex.Client.delete("containers/#{cid}")
  end

  defp run_docker(account, username, password, location) do
    result = Dockerex.Client.post("containers/create", %{"Image": "hisea/pbot",
                                                         "Tty": true,
                                                         "HostConfig": %{"RestartPolicy": %{ "Name": "always"}},
                                                         "Cmd": ["-a", account, "-u", username, "-p", password, "-l", location]})

    Dockerex.Client.post("containers/#{result["Id"]}/start")
    result
  end
end
