module SprocketsHelper
  def sprockets_include_tag(namespace = nil)
    return javascript_include_tag("/sprockets/#{namespace}.js") if namespace
    javascript_include_tag("/sprockets.js")
  end
end
