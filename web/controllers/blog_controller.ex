defmodule LiveBlog.BlogController do
  use LiveBlog.Web, :controller

  alias LiveBlog.Blog

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    render(conn, "blogs.json", blogs: Blog.list(user_id))
  end

  def create(conn, params) do
    user_id = get_session(conn, :user_id)

    case Blog.insert(user_id, params) do
      {:error, messages} ->
        conn
        |> put_status(400)
        |> render("errors.json", errors: format_errors(messages))
      {:ok, blog} ->
        render(conn, "blogs.json", blogs: [blog])
    end
  end

  def update(conn, params) do
    user_id = get_session(conn, :user_id)

    case Blog.update(user_id, params["id"], params) do
      {:error, messages} ->
        conn
        |> put_status(400)
        |> render("errors.json", errors: format_errors(messages))
      {:ok, blog} ->
        render(conn, "blogs.json", blogs: [blog])
    end
  end

  def delete(conn, %{"id" => id}) do
    get_session(conn, :user_id)
    |> Blog.delete(id)

    conn 
    |> put_status(204)
  end

  defp format_errors(messages) do
    Enum.map(messages, fn({field, message}) ->
      capitalized_field = Atom.to_string(field) |> String.capitalize
      case message do
        {_text, count} ->
          %{ field: field, message: "#{capitalized_field} should be at least #{count} characters." }
        _ ->
          %{ field: field, message: message }
      end
    end)
  end
  
end
