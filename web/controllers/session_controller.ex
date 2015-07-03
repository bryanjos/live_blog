defmodule LiveBlog.SessionController do
  use LiveBlog.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"username" => username, "password" => password}) do
    case LiveBlog.Auth.login(username, password) do
      :not_found ->
        conn 
        |> put_status(401)
        |> put_flash(:error, "Invalid username or password")
        |> render("index.html")
      {:ok, user} ->
        conn 
        |> put_session(:user_id, user.id)
        |> put_flash(:success, "Logged in successfully")
        |> redirect to: "/dashboard"
    end
  end

  def destroy(conn, _params) do
    conn
    |> clear_session
    |> redirect to: "/"
  end
end
