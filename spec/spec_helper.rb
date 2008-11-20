require 'rubygems' rescue nil
require 'spec'

ROOT_DIR = File.dirname(__FILE__)
$: << File.expand_path("#{ROOT_DIR}/../lib")

require 'method_lister'

Spec::Runner.configure do |config|
  config.mock_with :rr
end
