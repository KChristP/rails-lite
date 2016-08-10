require 'rack'

# app1 = Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['hello world']] }

# Rack::Server.start(
#   app: Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['hello world']] }
#   Port: 3000
# )

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  res.write(req.path)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
