defmodule LiveBlog.BlogControllerTest do
  use LiveBlog.ConnCase

  alias LiveBlog.Blog

  @valid_attrs %{"name" => "test blog", "slug" => "test-blog"}
  @invalid_attrs %{"name" => "test blog", "slug" => ""}

  setup do
    conn = post conn(), "/sign/up", %{"user" => %{ "username" => "test", "password" => "testtest", "email" => "test@example.com" } }
    {:ok, user} = LiveBlog.Auth.login("test", "testtest")
    {:ok, conn: conn, user: user }
  end

  test "GET /api/blogs", context do
    conn = get context[:conn], "/api/blogs"

    body = json_response(conn, 200)
    assert body["blogs"] == []
  end

  test "POST /api/blogs - invalid", context do
    conn = post context[:conn], "/api/blogs", @invalid_attrs

    body = json_response(conn, 400)
    assert %{"field" => "slug", "message" => "Slug should be at least 4 characters."} in body["errors"]
  end

  test "POST /api/blogs", context do
    conn = post context[:conn], "/api/blogs", @valid_attrs

    body = json_response(conn, 200)
    assert hd(body["blogs"])["name"] == "test blog"  
  end

  test "PUT /api/blogs - invalid", context do
    conn = post context[:conn], "/api/blogs", @valid_attrs

    blog = hd(Blog.list(context[:user].id))

    conn = put conn, "/api/blogs/#{blog.id}", %{ "name" => "" }
    body = json_response(conn, 400)
    assert %{"field" => "name", "message" => "Name should be at least 4 characters."} in body["errors"]  
  end

  test "PUT /api/blogs", context do
    conn = post context[:conn], "/api/blogs", @valid_attrs

    blog = hd(Blog.list(context[:user].id))

    conn = put conn, "/api/blogs/#{blog.id}", %{ "name" => "test blog 2" }
    body = json_response(conn, 200)
    assert hd(body["blogs"])["name"] == "test blog 2"    
  end

  test "DELETE /api/blogs", context do
    conn = post context[:conn], "/api/blogs", @valid_attrs

    blog = hd(Blog.list(context[:user].id))

    conn = delete conn, "/api/blogs/#{blog.id}"
    assert conn.status == 204
  end
  
end
