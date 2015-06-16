defmodule LiveBlog.BlogTest do
  use LiveBlog.ModelCase

  alias LiveBlog.Blog
  alias LiveBlog.User

  @valid_attrs %{name: "some content", slug: "content"}
  @invalid_attrs %{}

  setup do
    user_attrs = %{email: "some@content", isAdmin: true, password: "some content", username: "some content"}
    {:ok, user } = User.insert(user_attrs)
    {:ok, [user: user]}
  end

  test "insert", context do
    {:ok, blog } = Blog.insert(context[:user].id, @valid_attrs)
    assert blog != nil
  end

  test "update", context do
    {:ok, blog } = Blog.insert(context[:user].id, @valid_attrs)

    {:ok, blog } = Blog.update(context[:user].id, blog.id, @valid_attrs)
    assert blog != nil
  end

  test "update invalid user", context do
    {:ok, blog } = Blog.insert(context[:user].id, @valid_attrs)

    {:error, messages } = Blog.update(4, blog.id, @valid_attrs)
    assert messages == [blog: "Blog not found"]
  end

  test "delete", context do
    {:ok, blog } = Blog.insert(context[:user].id, @valid_attrs)
    Blog.delete(context[:user].id, blog.id)
  end
end
