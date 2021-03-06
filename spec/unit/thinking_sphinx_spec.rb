require 'spec/spec_helper'

describe ThinkingSphinx do
  describe "indexed_models methods" do
    it "should contain all the names of models that have indexes" do
      ThinkingSphinx.indexed_models.should include("Person")
    end
  end
  
  it "should define indexes by default" do
    ThinkingSphinx.define_indexes?.should be_true
  end
  
  it "should disable index definition" do
    ThinkingSphinx.define_indexes = false
    ThinkingSphinx.define_indexes?.should be_false
  end
  
  it "should enable index definition" do
    ThinkingSphinx.define_indexes = false
    ThinkingSphinx.define_indexes?.should be_false
    ThinkingSphinx.define_indexes = true
    ThinkingSphinx.define_indexes?.should be_true
  end
  
  it "should index deltas by default" do
    ThinkingSphinx.deltas_enabled?.should be_true
  end
  
  it "should disable delta indexing" do
    ThinkingSphinx.deltas_enabled = false
    ThinkingSphinx.deltas_enabled?.should be_false
  end
  
  it "should enable delta indexing" do
    ThinkingSphinx.deltas_enabled = false
    ThinkingSphinx.deltas_enabled?.should be_false
    ThinkingSphinx.deltas_enabled = true
    ThinkingSphinx.deltas_enabled?.should be_true
  end
  
  describe "use_group_by_shortcut? method" do
    after :each do
      ::ActiveRecord::Base.connection.unstub_method(:select_all)
    end
    
    it "should return true if no ONLY_FULL_GROUP_BY" do
      ::ActiveRecord::Base.connection.stub_method(
        :select_all => {:a => "OTHER SETTINGS"}
      )
      
      ThinkingSphinx.use_group_by_shortcut?.should be_true
    end
  
    it "should return true if NULL value" do
      ::ActiveRecord::Base.connection.stub_method(
        :select_all => {:a => nil}
      )
      
      ThinkingSphinx.use_group_by_shortcut?.should be_true
    end
  
    it "should return false if ONLY_FULL_GROUP_BY is set" do
      ::ActiveRecord::Base.connection.stub_method(
        :select_all => {:a => "OTHER SETTINGS,ONLY_FULL_GROUP_BY,blah"}
      )
      
      ThinkingSphinx.use_group_by_shortcut?.should be_false
    end
    
    it "should return false if ONLY_FULL_GROUP_BY is set in any of the values" do
      ::ActiveRecord::Base.connection.stub_method(
        :select_all => {
          :a => "OTHER SETTINGS",
          :b => "ONLY_FULL_GROUP_BY"
        }
      )
      
      ThinkingSphinx.use_group_by_shortcut?.should be_false
    end
  end
end