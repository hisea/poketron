defmodule Poketron.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :image, :text

      timestamps()
    end

  end
end
