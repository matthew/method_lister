require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe MethodLister::FindResult do
  before do
    names = %w{foo bar baz}
    @public    = names.map {|m| "public_#{m}"}
    @protected = names.map {|m| "protected_#{m}"}
    @private   = names.map {|m| "private_#{m}"}
    @all       = @public + @protected + @private

    @object         = Object.new
    @empty_result   = MethodLister::FindResult.new(:object => @object)
    @only_public    = MethodLister::FindResult.new(:object => @object, 
                                                   :public => @public)
    @only_protected = MethodLister::FindResult.new(:object => @object, 
                                                   :protected => @protected)
    @only_private   = MethodLister::FindResult.new(:object => @object,
                                                   :private => @private)
    @mixed_result   = MethodLister::FindResult.new(:object => @object,
                                                   :public => @public,
                                                   :protected => @protected,
                                                   :private => @private)
  end
  
  describe "#object" do
    it "requires at least an associated object" do
      lambda do
        MethodLister::FindResult.new(:public => @public)
      end.should raise_error(ArgumentError)
    end
    
    it "knows its associated object" do
      @empty_result.object.should == @object
    end
  end
  
  describe "#methods" do
    it "knows all its methods" do
      @empty_result.methods(:all).should be_empty
      @only_public.methods(:all).should == @public
      @only_protected.methods(:all).should == @protected
      @only_private.methods(:all).should == @private
      @mixed_result.methods(:all).should == @all
    end

    it "knows its public methods" do
      @empty_result.methods(:public).should be_empty
      @only_public.methods(:public).should == @public
      @only_protected.methods(:public).should be_empty
      @only_private.methods(:public).should be_empty
      @mixed_result.methods(:public).should == @public
    end

    it "knows its protected methods" do
      @empty_result.methods(:protected).should be_empty
      @only_public.methods(:protected).should be_empty
      @only_protected.methods(:protected).should == @protected
      @only_private.methods(:protected).should be_empty
      @mixed_result.methods(:protected).should == @protected
    end

    it "knows its private methods" do
      @empty_result.methods(:private).should be_empty
      @only_public.methods(:private).should be_empty
      @only_protected.methods(:private).should be_empty
      @only_private.methods(:private).should == @private
      @mixed_result.methods(:private).should == @private
    end
    
    it "raises an exception if given an unknown visibility" do
      lambda do
        @empty_result.methods(:foobar) 
      end.should raise_error(ArgumentError)
    end
  end

  describe "#has_methods?" do
    it "knows if it has methods of any visibility" do
      @empty_result.should_not have_methods
      @only_public.should have_methods
      @only_protected.should have_methods
      @only_private.should have_methods
      @mixed_result.should have_methods
    end

    it "knows if it has methods of visibility :all" do
      @empty_result.should_not have_methods(:all)
      @only_public.should have_methods(:all)
      @only_protected.should have_methods(:all)
      @only_private.should have_methods(:all)
      @mixed_result.should have_methods(:all)
    end
    
    it "knows if it has methods of visibility :public" do
      @empty_result.should_not have_methods(:public)
      @only_public.should have_methods(:public)
      @only_protected.should_not have_methods(:public)
      @only_private.should_not have_methods(:public)
      @mixed_result.should have_methods(:public)
    end

    it "knows if it has methods of visibility :protected" do
      @empty_result.should_not have_methods(:protected)
      @only_public.should_not have_methods(:protected)
      @only_protected.should have_methods(:protected)
      @only_private.should_not have_methods(:protected)
      @mixed_result.should have_methods(:protected)
    end

    it "knows if it has methods of visibility :private" do
      @empty_result.should_not have_methods(:private)
      @only_public.should_not have_methods(:private)
      @only_protected.should_not have_methods(:private)
      @only_private.should have_methods(:private)
      @mixed_result.should have_methods(:private)
    end
  end
  
  describe "#remove_methods_matching!" do
    it "removes all methods matching the given regex" do
      rx = /foo/
      @mixed_result.methods(:all).select {|meth| meth =~ rx}.should_not be_empty 
      @mixed_result.remove_methods_matching!(rx)
      @mixed_result.methods(:all).select {|meth| meth =~ rx}.should be_empty 
    end
  end
end
