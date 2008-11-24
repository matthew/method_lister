def all_find_scenarios
  FindScenario.load_all
end

class FindScenario
  attr_reader :name, :object, :expected
  
  def initialize(filename)
    @filename = filename
    @name = File.basename(@filename).gsub(/\.rb$/, "")
  end
  
  def setup!
    FindScenarioNameSpace.reset!
    load @filename
    @object = FindScenarioNameSpace.object
    @expected = FindScenarioNameSpace.expected
  end
  
  class << self
    def load_all
      Dir["#{scenario_dir}/*.rb"].map {|file| new(file)}
    end

    private
    
    def scenario_dir
      File.expand_path(File.dirname(__FILE__) + "/../../scenarios")
    end
  end
end

module FindScenarioNameSpace
  class << self
    attr_reader :object, :expected
  
    def reset!
      constants.each do |constant|
        remove_const(constant)
      end
      @object = nil
      @expected = nil
    end
  end
end