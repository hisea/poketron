defmodule Poketron.GameView do
  use Poketron.Web, :view
  alias Poketron.Game
  alias Poketron.Repo

  def docker_status(id) do
    case Dockerex.Client.get("containers/#{id}/json") do
      %{"State" => %{"Status" => status}} -> status |> String.capitalize
      _ ->
        game = Game
        |> Game.by_cid(id)
        |> Repo.one

        Game.changeset(game, %{status: "Deleted", deleted_at: Ecto.DateTime.utc})
        |> Repo.update
        "Deleted"
    end
  end

  def short_cid(cid) do
    cid
    |> String.split_at(12)
    |> elem(0)
  end
end
