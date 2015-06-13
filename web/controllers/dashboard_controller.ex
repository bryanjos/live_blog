defmodule LiveBlog.DashboardController do
  use LiveBlog.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end