require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe MethodLister::FindResult do
  before do
    names = %w{foo bar baz}
    @public    = names.map {|m| "public_#{m}"}
    @protected = names.map {|m| "protected_#{m}"}
    @private   = names.map {|m| "private_#{m}"}
    @all       = @public + @protected + @private

    @object         = Object.new
    @empty_result   = MethodLister::FindResult.new(@object)
    @only_public    = MethodLister::FindResult.new(@object, 
                                                   :public => @public)
    @only_protected = MethodLister::FindResult.new(@object, 
                                                   :protected => @protected)
    @only_private   = MethodLister::FindResult.new(@object,
                                                   :private => @private)
    @mixed_result   = MethodLister::FindResult.new(@object,
                                                   :public => @public,
                                                   :protected => @protected,
                                                   :private => @private)
  end
  
  describe "#object" do
    it "works even if object is nil" do
      result = MethodLister::FindResult.new(nil, :public => @public)
      result.object.should be_nil
    end
    
    it "knows its associated object" do
      @empty_result.object.should == @object
    end
  end
  
  describe "#methods" do
    it "knows all its methods" do
      @empty_result.methods(:all).should be_empty
      @only_public.methods(:all).should == @public.sort
      @only_protected.methods(:all).should == @protected.sort
      @only_private.methods(:all).should == @private.sort
      @mixed_result.methods(:all).should == @all.sort
    end

    it "knows its public methods" do
      @empty_result.methods(:public).should be_empty
      @only_public.methods(:public).should == @public.sort
      @only_protected.methods(:public).should be_empty
      @only_private.methods(:public).should be_empty
      @mixed_result.methods(:public).should == @public.sort
    end

    it "knows its protected methods" do
      @empty_result.methods(:protected).should be_empty
      @only_public.methods(:protected).should be_empty
      @only_protected.methods(:protected).should == @protected.sort
      @only_private.methods(:protected).should be_empty
      @mixed_result.methods(:protected).should == @protected.sort
    end

    it "knows its private methods" do
      @empty_result.methods(:private).should be_empty
      @only_public.methods(:private).should be_empty
      @only_protected.methods(:private).should be_empty
      @only_private.methods(:private).should == @private.sort
      @mixed_result.methods(:private).should == @private.sort
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
  
  describe "#narrow_to_methods_matching!" do
    it "removes all methods not matching the given regex" do
      rx = /foo/
      @mixed_result.methods(:all).select {|meth| meth !~ rx}.should_not be_empty 
      @mixed_result.narrow_to_methods_matching!(rx)
      @mixed_result.methods(:all).select {|meth| meth !~ rx}.should be_empty 
    end
    
    it "never removes method_missing" do
      @private << "method_missing"
      rx = /foo/
      @mixed_result.methods(:all).select {|meth| meth !~ rx}.should_not be_empty 
      @mixed_result.narrow_to_methods_matching!(rx)
      @mixed_result.methods(:all).select {|meth| meth !~ rx}.should be_include("method_missing")
    end
  end
  
  describe "#==" do
    it "is equal if both have the same methods and object" do
      @mixed_result.should == MethodLister::FindResult.new(
        @mixed_result.object,
        :public    => @mixed_result.methods(:public),
        :protected => @mixed_result.methods(:protected),
        :private   => @mixed_result.methods(:private)
      )
    end
    
    it "is not equal if both have same methods but different objects" do
      @mixed_result.should_not == MethodLister::FindResult.new(
        Object.new,
        :public    => @mixed_result.methods(:public),
        :protected => @mixed_result.methods(:protected),
        :private   => @mixed_result.methods(:private)
      )
    end

    it "is not equal if both have the same object but different methods" do
      @mixed_result.should_not == MethodLister::FindResult.new(
        @mixed_result.object,
        :public    => ["something_else"]
      )
    end
  end
end
