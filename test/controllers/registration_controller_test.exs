defmodule LiveBlog.RegistrationControllerTest do
  use LiveBlog.ConnCase

  test "GET /sign/up" do
    conn = get conn(), "/sign/up"
    assert html_response(conn, 200) =~ "Username"
  end

  test "POST /sign/up - invalid" do
    conn = post conn(), "/sign/up", %{}
    assert html_response(conn, 200) =~ "password can&#39;t be blank"
  end

  test "POST /sign/up - valid" do
    conn = post conn(), "/sign/up", %{"username" => "test", "password" => "testtest", "email" => "test@example.com"}
    assert redirected_to(conn) =~ "/"
  end
end
