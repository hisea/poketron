defmodule Poketron.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :user_id, references(:users)
      add :container_id, :string

      timestamps()
    end
  end
end
