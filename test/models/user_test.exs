defmodule LiveBlog.UserTest do
  use LiveBlog.ModelCase

  alias LiveBlog.User

  @valid_attrs %{email: "some@content", isAdmin: true, password: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "insert" do
    {:ok, user } = User.insert(@valid_attrs)
    assert user != nil
  end

  test "changeset invalid when email is not unique" do
    {:ok, user } = User.insert(@valid_attrs)
    assert user != nil

    {:error, messages } = User.insert(@valid_attrs)
    assert Keyword.has_key?(messages, :email) == true
    assert Keyword.has_key?(messages, :username) == true
  end

  test "update" do
    {:ok, user } = User.insert(@valid_attrs)
    assert user.isAdmin

    {:ok, user } = User.update(user.id, %{isAdmin: false})
    refute user.isAdmin
  end

  test "get" do
    {:ok, _ } = User.insert(@valid_attrs)

    user = User.get(%{ "username" => @valid_attrs.username, "password" => @valid_attrs.password })
    assert user != nil

    user = User.get(%{ "username" => "blah", "password" => @valid_attrs.password })
    assert user == nil
  end

  test "valid login" do
    {:ok, _ } = User.insert(@valid_attrs)

    {status, user} = User.login(%{ "username" => @valid_attrs.username, "password" => @valid_attrs.password })

    assert status == :ok
    assert user.username == @valid_attrs.username
  end

  test "invalid login" do
    {status} = User.login(%{ "username" => @valid_attrs.username, "password" => @valid_attrs.password })
    assert status == :not_found
  end
end
