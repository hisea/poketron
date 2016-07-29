defmodule Poketron.Plug.AssignUser do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    if user do
      assign(conn, :user, user)
    else
      conn
    end
  end
end
