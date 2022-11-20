
# Configure your database
config :example_app, ExampleApp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "example_app_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
