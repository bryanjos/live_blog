defmodule LiveBlog.Router do
  use LiveBlog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  def logged_in(conn, _opts) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        Plug.Conn.send_resp(conn, 401, "Unauthorized")
      _ ->
        conn
    end
  end

  pipeline :secure do
    plug :logged_in, %{}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveBlog do
    pipe_through :browser

    get "/", PageController, :index

    get   "/sign/up",   RegistrationController, :index
    post  "/sign/up",   RegistrationController, :create

    get   "/sign/in",   SessionController, :index
    post  "/sign/in",   SessionController, :create
    get   "/sign/out",  SessionController, :destroy
  end

  scope "/", LiveBlog do
    pipe_through [:browser, :secure]

    get "/dashboard", DashboardController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveBlog do
  #   pipe_through :api
  # end
end
