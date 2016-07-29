defmodule Poketron.AuthHandler do
  use Poketron.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: "/")
  end
end
