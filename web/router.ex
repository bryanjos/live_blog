defmodule LiveBlog.Router do
  use LiveBlog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveBlog do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get   "/sign/up",   RegistrationController, :index
    post  "/sign/up",   RegistrationController, :create

    get   "/sign/in",   SessionController, :index
    post  "/sign/in",   SessionController, :create
    get   "/sign/out",  SessionController, :destroy
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveBlog do
  #   pipe_through :api
  # end
end
