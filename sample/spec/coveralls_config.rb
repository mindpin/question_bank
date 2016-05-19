require "simplecov"

base_path = File.expand_path("../../../", __FILE__)
SimpleCov.root(base_path)

SimpleCov.start do
  add_filter File.join(base_path, "sample/spec")
  add_group "Models", File.join(base_path, "app/models")
  add_group "controller", File.join(base_path, "app/controllers")
  add_group "lib",    File.join(base_path, "lib")
end

if ENV["CI"] == "true"
  require "coveralls"
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end
