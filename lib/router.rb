class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name = pattern, http_method, controller_class, action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)

    @pattern =~ req.path && @http_method == req.request_method.downcase.to_sym
    # req.each_header do |header, value|
    #   @pattern =~ value
    # end
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    controller = @controller_class.new(req, res)
    controller.invoke_action(@action_name)
    #turn controller_name into an actual controller and instantiate it
    #then call invoke_action(name) on it(idk why not just call controller.name...)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # def make_http_method_function(method)
  #   define_method(method) do
  #     add_route(@pattern, method, @controller_class, @action_name)
  #   end
  # end

  # def get(pattern, controller_class, action_name)
  #   add_route(pattern, "GET", controller_class, action_name)
  # end
  # def post(pattern, controller_class, action_name)
  #   add_route(pattern, "POST", controller_class, action_name)
  # end
  # def patch(pattern, controller_class, action_name)
  #   add_route(pattern, "PATCH", controller_class, action_name)
  # end
  # def delete(pattern, controller_class, action_name)
  #   add_route(pattern, "DELETE", controller_class, action_name)
  # end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    @routes.each do |route|
      return route if route.matches?
    end
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
  end#
end
