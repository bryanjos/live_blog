defmodule LiveBlog.LayoutView do
  use LiveBlog.Web, :view

  def logged_in?(conn) do
    get_session(conn, :user_id) != nil
  end

end
