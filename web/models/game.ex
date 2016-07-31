defmodule Poketron.Game do
  use Poketron.Web, :model

  schema "games" do
    belongs_to :user, Poketron.User
    field :container_id, :string
    field :status, :string
    field :deleted_at, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :container_id, :status, :deleted_at])
    |> validate_required([:user_id, :container_id])
  end

  def for_user(query, user) do
    from q in query,
      where: q.user_id == ^user.id
  end

  def by_cid(query, cid) do
    from q in query,
      where: q.container_id == ^cid
  end

  def running(query) do
    from q in query,
      where: is_nil(q.deleted_at)
  end
end
