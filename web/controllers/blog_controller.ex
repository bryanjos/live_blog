defmodule LiveBlog.BlogController do
  use LiveBlog.Web, :controller

  alias LiveBlog.Blog

  plug :scrub_params, "blog" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    render(conn, "index.html", blogs: Blog.list(user_id))
  end

  def new(conn, _params) do
    changeset = Blog.changeset(%Blog{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"blog" => blog_params}) do
    changeset = Blog.changeset(%Blog{}, blog_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "Blog created successfully.")
      |> redirect(to: blog_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    blog = Repo.get(Blog, id)
    render(conn, "show.html", blog: blog)
  end

  def edit(conn, %{"id" => id}) do
    blog = Repo.get(Blog, id)
    changeset = Blog.changeset(blog)
    render(conn, "edit.html", blog: blog, changeset: changeset)
  end

  def update(conn, %{"id" => id, "blog" => blog_params}) do
    blog = Repo.get(Blog, id)
    changeset = Blog.changeset(blog, blog_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "Blog updated successfully.")
      |> redirect(to: blog_path(conn, :index))
    else
      render(conn, "edit.html", blog: blog, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    blog = Repo.get(Blog, id)
    Repo.delete(blog)

    conn
    |> put_flash(:info, "Blog deleted successfully.")
    |> redirect(to: blog_path(conn, :index))
  end
end
