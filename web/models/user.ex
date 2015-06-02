defmodule LiveBlog.User do
  use LiveBlog.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :isAdmin, :boolean, default: false

    timestamps
  end

  @required_fields ~w(username email password isAdmin)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:username, min: 4)
    |> validate_length(:password, min: 8)
    |> validate_unique(:username, on: LiveBlog.Repo)
    |> validate_unique(:email, on: LiveBlog.Repo)
  end

  def get(id) do
    LiveBlog.Repo.get(LiveBlog.User, id)
  end

  def insert(params) do
    changeset = LiveBlog.User.changeset(%LiveBlog.User{}, params)

    case changeset.valid? do
      false ->
        {:error, changeset.errors}
      _ ->
        changeset = update_change(changeset, :password, &Comeonin.Bcrypt.hashpwsalt(&1))
        {:ok, LiveBlog.Repo.insert(changeset) }
    end
  end

  def update(id, params) do
    changeset = LiveBlog.User.changeset(get(id), params)
     
    case changeset.valid? do
      false ->
        {:error, changeset.errors}
      _ ->
        if get_change(changeset, :password, nil) do
          changeset = update_change(changeset, :password, &Comeonin.Bcrypt.hashpwsalt(&1))
        end

        {:ok, LiveBlog.Repo.update(changeset) }
    end
  end

  def delete(id) do
    user = get(id)
    LiveBlog.Repo.delete(user)
  end
end
