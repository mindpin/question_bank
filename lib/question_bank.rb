require 'enumerize'
require 'simple_form'
# 引用 rails engine
require 'question_bank/engine'
Dir.glob(File.join(File.expand_path("../../",__FILE__), "app/models/question_bank/concerns/**.rb")).each do |file|
  require file
end
