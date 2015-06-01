defmodule LiveBlog.Endpoint do
  use Phoenix.Endpoint, otp_app: :live_blog

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :live_blog, gzip: false,
    only: ~w(css images js favicon.ico robots.txt jspm_packages config.js)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_live_blog_key",
    signing_salt: "Fo6ZAz3K"

  plug :router, LiveBlog.Router
end
