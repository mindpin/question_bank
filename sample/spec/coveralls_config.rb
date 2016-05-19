require "simplecov"

base_path = File.expand_path("../../../", __FILE__)
SimpleCov.root(base_path)

SimpleCov.start do
  add_filter File.join(base_path, "sample/spec")
  add_filter File.join(base_path, "sample/config")
  add_filter File.join(base_path, "config")

  add_group "models", File.join(base_path, "app/models")
  add_group "lib",    File.join(base_path, "lib")
end

if ENV["CI"] == "true"
  require "coveralls"
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end
