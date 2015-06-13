defmodule LiveBlog.Auth do
  import Ecto.Query

  def login(username, password) do
    query = from u in LiveBlog.User,
            where: u.username == ^username or u.email == ^username,
            select: u
    user = LiveBlog.Repo.one(query)

    cond do
      user == nil ->
        #Doing a false checkpw to prevent timing attacks
        fake_password_check

        :not_found
      !check_password(password, user.password) ->
        :not_found
      true ->
        {:ok, user}
    end
  end

  def encrypt_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  defp check_password(password, password_hash) do
    Comeonin.Bcrypt.checkpw(password, password_hash)
  end

  defp fake_password_check() do
    Comeonin.Bcrypt.checkpw("", Comeonin.Bcrypt.hashpwsalt("fake_password_check"))
  end


end