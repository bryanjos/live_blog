defmodule LiveBlog.PageController do
  use LiveBlog.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
