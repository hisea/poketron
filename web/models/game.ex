defmodule Poketron.Game do
  use Poketron.Web, :model

  schema "games" do
    belongs_to :user, Poketron.User
    field :container_id, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :container_id])
    |> validate_required([:user_id, :container_id])
  end

  def for_user(query, user) do
    from q in query,
      where: q.user_id == ^user.id
  end
end
