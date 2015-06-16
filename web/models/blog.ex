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

  def get(user_id, id) do
    query = from blog in LiveBlog.Blog,
        where: blog.user_id == ^user_id and blog.id == ^id,
        select: blog
    blog = LiveBlog.Repo.one(query)
  end

  def list(user_id) do
    query = from blog in LiveBlog.Blog,
            where: blog.user_id == ^user_id,
            select: blog
    LiveBlog.Repo.all(query)
  end

  def insert(user_id, params) do
    changeset = LiveBlog.Blog.changeset(%LiveBlog.Blog{user_id: user_id}, params)

    case changeset.valid? do
      false ->
        {:error, changeset.errors}
      _ ->
        {:ok, LiveBlog.Repo.insert(changeset) }
    end
  end

  def update(user_id, id, params) do
    blog = get(user_id, id)

    case blog do
      nil ->
        {:error, [blog: "Blog not found"]}
      _ ->
        changeset = LiveBlog.Blog.changeset(blog, params)

        case changeset.valid? do
          false ->
            {:error, changeset.errors}
          _ ->
            {:ok, LiveBlog.Repo.update(changeset) }
        end       
    end
  end

  def delete(user_id, id) do
    blog = get(user_id, id)

    case blog do
      nil ->
        {:error, [blog: "Blog not found"]}
      _ ->
        LiveBlog.Repo.delete(blog)     
    end
  end
end
