defmodule LiveBlog.Blog do
  use LiveBlog.Web, :model

  schema "blogs" do
    field :name, :string
    field :slug, :string
    belongs_to :user, LiveBlog.User

    timestamps
  end

  @required_fields ~w(name slug)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 4)
    |> validate_length(:slug, min: 4)
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/)
    |> validate_unique(:name, scope: [:user_id], on: LiveBlog.Repo)
    |> validate_unique(:slug, scope: [:user_id], on: LiveBlog.Repo)
  end

  def list(user_id) do
    query = from blog in LiveBlog.Blog,
            where: blog.user_id == ^user_id,
            select: blog
    user = LiveBlog.Repo.one(query)
  end

  def insert(user_id, %{ "name" => name, "slug" => slug }) do
    changeset = LiveBlog.Blog.changeset(%LiveBlog.Blog{}, Map.put(params, "user_id", user_id))

    case changeset.valid? do
      false ->
        {:error, changeset.errors}
      _ ->
        {:ok, LiveBlog.Repo.insert(changeset) }
    end
  end

  def update(id, %{ "name" => name, "slug" => slug }) do
    changeset = LiveBlog.Blog
    |> LiveBlog.Repo.get(id)
    |> LiveBlog.Blog.changeset(params)

    case changeset.valid? do
      false ->
        {:error, changeset.errors}
      _ ->
        {:ok, LiveBlog.Repo.update(changeset) }
    end
  end

  def delete(id) do
    LiveBlog.Blog
    |> LiveBlog.Repo.get(id)
    |> LiveBlog.Repo.delete
  end
end
