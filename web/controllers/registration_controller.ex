defmodule LiveBlog.RegistrationController do
  use LiveBlog.Web, :controller

  plug :action
  plug :scrub_params, "user" when action in [:create]

  def index(conn, _params) do
    render conn, "index.html", %{user: %{}}
  end

  def create(conn, params) do
    user = Map.get(params, "user")
    case LiveBlog.User.insert(user) do
      {:error, errors} ->
        messages = Enum.map(errors, fn({field, message}) ->
          field = Atom.to_string(field) |> String.capitalize
          case message do
            {text, count} ->
              "#{field} should be at least #{count} characters."
            _ ->
              "#{field} #{message}."
          end
        end)

        conn
        |> put_flash(:validation_error, messages)
        |> render("index.html", %{user: user})
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:success, "Registration successful")
        |> redirect to: "/"
    end
  end
end
