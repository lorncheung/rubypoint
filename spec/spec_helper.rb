require 'rubygems'
require 'bundler/setup'
require 'rubypoint'

class RubyPoint
  def self.working_directory
    'spec/tmp/'
  end
end

RSpec.configure do |config|

  def doc_from(object)
    Hpricot::XML(File.open(object.file_path).read)
  end
  
  config.after :each do
    RubyPoint.clear_working_directory
  end
  
end