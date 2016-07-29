defmodule Poketron.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Poketron.Repo
  alias Poketron.User

  def for_token(user = %User{}) do
    { :ok, "User:#{user.id}" }
  end

  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, Repo.get(User, id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
