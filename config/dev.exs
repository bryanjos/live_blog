use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :live_blog, LiveBlog.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  watchers: [node: ["node_modules/gulp/bin/gulp.js", "watch"]]

# Watch static and templates for browser reloading.
config :live_blog, LiveBlog.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :live_blog, LiveBlog.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "live_blog_dev",
  size: 10 # The amount of database connections in the pool

#session
config :live_blog, LiveBlog.Endpoint,
  secret_key_base: "fq#j@-wk(v+^mrgw@62$##oz8m##09az@uz06hp-bd!rn@ju8506hp-bd!rn@ju85"

config :phoenix, LiveBlog.Router,
  session: [store: :cookie, key: "_live_blog_key"]
