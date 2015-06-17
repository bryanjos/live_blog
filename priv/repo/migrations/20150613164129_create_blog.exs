defmodule LiveBlog.Repo.Migrations.CreateBlog do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :name, :string
      add :slug, :string
      add :user_id, :integer

      timestamps
    end

    create index(:blogs, [:user_id])
    create index(:blogs, [:user_id, "lower(name)"], unique: true)
    create index(:blogs, [:user_id, :slug], unique: true)

    create index :users, ["lower(email)", "lower(username)"]
  end
end
