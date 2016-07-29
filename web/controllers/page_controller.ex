defmodule Poketron.PageController do
  use Poketron.Web, :controller
  plug Poketron.Plug.AssignUser

  def index(conn, _params) do
    render conn, "index.html"
  end
end
