defmodule Poketron.Repo.Migrations.AddStatusToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :status, :string
      add :deleted_at, :timestamp
    end
  end
end
