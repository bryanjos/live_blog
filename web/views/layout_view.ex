defmodule LiveBlog.LayoutView do
  use LiveBlog.Web, :view

  alias LiveBlog.Repo
  alias LiveBlog.User

  def current_user(conn) do
    user_id = get_session(conn, :user_id)
    if user_id do
      Repo.get(User, user_id)
    else
      nil
    end
  end

end
