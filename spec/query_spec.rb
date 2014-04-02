require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module MockQuery
  def self.conditions(&block)
    conditions = Query::Conditions.new(&block)
  end
end 

describe "query" do

  context "using the dsl in mocked search" do

    let(:dsl_query_matching) do
      MockQuery::conditions do |dummy|
         dummy.name == "Miles"
         dummy.hobby == "couch-surfing"
      end     
    end

    let(:dsl_query_fuzzy) do
      MockQuery::conditions do |dummy|
         dummy.name =~ "Mi"
         dummy.hobby =~ "surf"
      end     
    end

    it "build correct query string for matching search" do
      dsl_query_matching.to_search_conditions.should == "name:'Miles' AND hobby:'couch-surfing'"
    end 

    it "build correct query string for fuzzy search" do
      dsl_query_fuzzy.to_search_conditions.should == "name~'Mi' AND hobby~'surf'"
    end 
  end 
end      