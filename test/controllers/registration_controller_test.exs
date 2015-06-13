defmodule LiveBlog.RegistrationControllerTest do
  use LiveBlog.ConnCase

  test "GET /sign/up" do
    conn = get conn(), "/sign/up"
    assert html_response(conn, 200) =~ "Username"
  end

  test "POST /sign/up - invalid" do
    conn = post conn(), "/sign/up", %{"user" => %{ "username" => "", "password" => "", "email" => "" } }
    assert html_response(conn, 401) =~ "Password should be at least 8 characters"
    assert html_response(conn, 401) =~ "Username should be at least 4 characters"
    assert html_response(conn, 401) =~ "Email has invalid format"
  end

  test "POST /sign/up - valid" do
    conn = post conn(), "/sign/up", %{"user" => %{ "username" => "test", "password" => "testtest", "email" => "test@example.com" } }
    assert redirected_to(conn) =~ "/dashboard"
  end
end
