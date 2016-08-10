require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response ? true : false
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "You can't render twice witht he same ControllerBase instance"
    else
      @res.status = 302
      @res['Location'] = url
      @session.store_session(@res)
      @already_built_response = true
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    @res['Content-Type'] = content_type

    if @already_built_response
      raise "You can't render twice witht he same ControllerBase instance"
    else
      @res.write(content)
      @session.store_session(@res)
      @already_built_response = true
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    name = ActiveSupport::Inflector.underscore(self.class.name)#(__FILE__.split(".").take(1)[0].split("_") - ["controller"]).join("_")
    path = "views/#{name}/#{template_name}.html.erb"
    html = ERB.new(File.read(path)).result(binding)
    render_content(html, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)#this cant be right... why not just send the method from the router directly?
#how can I check if something was rendered?
    render(name)
  end
end
