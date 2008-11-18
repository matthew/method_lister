require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require 'method_finder'

describe MethodFinder do
  it "can find methods" do
    (1+1).should == 2
  end
end