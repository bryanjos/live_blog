defmodule LiveBlog.AuthTest do
  use LiveBlog.ModelCase

  alias LiveBlog.User
  alias LiveBlog.Auth

  @valid_attrs %{email: "some@content", isAdmin: true, password: "some content", username: "some content"}

  test "valid login" do
    {:ok, _ } = User.insert(@valid_attrs)

    {status, user} = Auth.login(@valid_attrs.username, @valid_attrs.password)

    assert status == :ok
    assert user.username == @valid_attrs.username
  end

  test "invalid login" do
    status = Auth.login(@valid_attrs.username, @valid_attrs.password)
    assert status == :not_found
  end
end
