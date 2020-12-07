ActiveRecord::Base.establish_connection(
  adapter: "sqlserver",
  host: ENV["ACCLTD_HOST"],
  database: ENV["ACCLTD_DB"],
  port: ENV["ACCLTD_PORT"],
  username: ENV["SAGE_USER"],
  password: ENV["SAGE_PASSWD"]
)
