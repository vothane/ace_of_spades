require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module MockSearch
  def self.search(&block)
    conditions = Query::Conditions.new(&block)
  end
end 

describe "query DSL" do
  context "using the dsl in mocked search" do

    let(:dsl_query_matching) do
      MockSearch::search do |search|
         search.name == "Miles"
         search.hobby == "couch-surfing"
      end     
    end

    let(:dsl_query_fuzzy) do
      MockSearch::search do |search|
         search.name =~ "Mi"
         search.hobby =~ "surf"
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