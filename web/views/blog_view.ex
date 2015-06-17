defmodule LiveBlog.BlogView do
  use LiveBlog.Web, :view

  def render("blogs.json", %{ blogs: blogs }) do
    %{ blogs: blogs }
  end

  def render("errors.json", %{ errors: errors }) do
    %{errors: errors}
  end
end
