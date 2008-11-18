ROOT_DIR = File.dirname(__FILE__)
$: << File.expand_path("#{ROOT_DIR}/../lib")

Spec::Runner.configure do |config|
  config.mock_with :rr
end