defmodule LiveBlog.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username,  :string
      add :email,     :string
      add :password,  :string
      add :isAdmin,   :boolean, default: false

      timestamps
    end

    create index :users, ["lower(username)"]
    create index :users, ["lower(email)"]

  end
end
