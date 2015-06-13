defmodule LiveBlog.SessionControllerTest do
  use LiveBlog.ConnCase

  test "GET /sign/in" do
    conn = get conn(), "/sign/in"
    assert html_response(conn, 200) =~ "Username"
  end

  test "POST /sign/in - invalid" do
    conn = post conn(), "/sign/in", %{ "username" => "", "password" => ""}
    assert html_response(conn, 401) =~ "Invalid username or password"
  end

  test "POST /sign/in - valid" do
    post conn(), "/sign/up", %{"user" => %{ "username" => "test", "password" => "testtest", "email" => "test@example.com" } }

    conn = post conn(), "/sign/in", %{ "username" => "test", "password" => "testtest"}
    assert redirected_to(conn) =~ "/dashboard"
  end
end
