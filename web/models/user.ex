defmodule Poketron.User do
  use Poketron.Web, :model

  schema "users" do
    field :name, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :image, :string
    has_many :games, Poketron.Game

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :first_name, :last_name, :email, :image])
    |> validate_required([:name, :first_name, :last_name, :email, :image])
  end
end
