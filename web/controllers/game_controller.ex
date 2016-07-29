defmodule Poketron.GameController do
  use Poketron.Web, :controller
  import Ecto.Changeset, only: [put_change: 3]
  plug Guardian.Plug.EnsureAuthenticated, handler: Poketron.AuthHandler
  plug Poketron.Plug.AssignUser

  alias Poketron.Game
  alias Poketron.Repo
  require IEx

  def index(conn, _params) do
    render conn, "index.html"
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
      %{err: nil, out: out, status: 0} ->
        cid = String.strip(out)
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
    
  end

  def destroy(conn, params) do
    
  end

  defp run_docker(account, username, password, location) do
    Porcelain.exec("docker", ["run","-d", "--restart=always","hisea/pbot", "-a", account, "-u", username, "-p", password, "-l", location])
  end
end
