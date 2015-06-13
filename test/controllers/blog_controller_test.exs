defmodule LiveBlog.BlogControllerTest do
  use LiveBlog.ConnCase

  alias LiveBlog.Blog
  @valid_attrs %{name: "some content", slug: "some content", user: nil}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, blog_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing blogs"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, blog_path(conn, :new)
    assert html_response(conn, 200) =~ "New blog"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, blog_path(conn, :create), blog: @valid_attrs
    assert redirected_to(conn) == blog_path(conn, :index)
    assert Repo.get_by(Blog, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, blog_path(conn, :create), blog: @invalid_attrs
    assert html_response(conn, 200) =~ "New blog"
  end

  test "shows chosen resource", %{conn: conn} do
    blog = Repo.insert %Blog{}
    conn = get conn, blog_path(conn, :show, blog)
    assert html_response(conn, 200) =~ "Show blog"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    blog = Repo.insert %Blog{}
    conn = get conn, blog_path(conn, :edit, blog)
    assert html_response(conn, 200) =~ "Edit blog"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    blog = Repo.insert %Blog{}
    conn = put conn, blog_path(conn, :update, blog), blog: @valid_attrs
    assert redirected_to(conn) == blog_path(conn, :index)
    assert Repo.get_by(Blog, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    blog = Repo.insert %Blog{}
    conn = put conn, blog_path(conn, :update, blog), blog: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit blog"
  end

  test "deletes chosen resource", %{conn: conn} do
    blog = Repo.insert %Blog{}
    conn = delete conn, blog_path(conn, :delete, blog)
    assert redirected_to(conn) == blog_path(conn, :index)
    refute Repo.get(Blog, blog.id)
  end
end
