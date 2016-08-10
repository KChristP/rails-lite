require 'rack'
require_relative '../lib/controller_base'

class MyController < ControllerBase
  def go
    session["count"] ||= 0
    session["count"] += 1
    render :counting_show
  end
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)

#server runs continuous loop listening to Port
#when port recieves information it is in form of env
#each time it gets env, it calls the app we send in (so app.call(env))
#each app.call(env) creates a new Request object that holds env information and a empty Response object
#1  #the app.call(env) then feeds the Request and Response objects to MyController
      #the app.call specifically calls one of MyController's functions (eg new, index etc)
      #MyController inherits from our ControllerBase class, giving it functionality to
      #modify/mutate the Response object by passing in html code (which is built in our html.erb views)
    #the app.call(env) function finishes after Mycontroller has mutated the response
    #and sends information from the Response object back to the server ... and to the client???
#2  #app.call now feeds the Request and Response objects to a Router object instead of controller
    #the router checks the Request obj and finds the http_method and url path info inside it
    #to decide which Controller to call. It creates a Route object that holds this data
    #the Route object is what eventually initializes an individual controller with the right info
