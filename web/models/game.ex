defmodule Poketron.Game do
  use Poketron.Web, :model

  schema "games" do
    field :user_id, :integer
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
end
