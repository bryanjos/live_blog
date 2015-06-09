defmodule LiveBlog.RegistrationController do
  use LiveBlog.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html", %{user: %{}}
  end

  def create(conn, params) do
    user = Map.get(params, "user")
    case LiveBlog.User.insert(user) do
      {:error, messages} ->
        message = Enum.map(messages, fn({field, message}) ->
          case message do
            {text, count} ->
              "#{field} should be at least #{count} characters"
            _ ->
              "#{field} #{message}"
          end
        end)
        |> Enum.join(". ")

        conn
        |> put_flash(:error, message)
        |> render("index.html", %{user: user})
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:success, "Registration successful")
        |> redirect to: "/"
    end
  end
end
