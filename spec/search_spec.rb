require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ace_of_spades' do

  class Poker < ActiveRecord::Base
    ace_of_spades( {:server_address => 'druby://localhost:12345'} )

    searchable do 
      text :suit, :rank, :value
    end
  end

  context "when committing to index by saving and then searching on index" do

    before :all do
      card1 = Poker.new( suit: "Hearts",   rank: "King",  value: 13 )
      card2 = Poker.new( suit: "Spades",   rank: "Ace",   value: 14 )
      card3 = Poker.new( suit: "Clubs",    rank: "Jack",  value: 11 )
      card4 = Poker.new( suit: "Diamonds", rank: "Three", value:  3 )
      card5 = Poker.new( suit: "Clubs",    rank: "Queen", value: 12 )

      card1.save
      card2.save
      card3.save
      card4.save
      card5.save
    end
    
    it "should find by field" do
      result1 = Poker.search(suit: "Spades")
      result2 = Poker.search(rank: "Ace")
      result3 = Poker.search(value: 14)

      result1.size.should == 1
      result2.size.should == 1
      result3.size.should == 1
      
      # delete id from result, value is nondeterministic unless using mocks
      (result1.map { |hash| hash.tap { |h| h.delete(:id) } }).should include( {:suit => "Spades", :rank => "Ace", :value => 14} )
      (result2.map { |hash| hash.tap { |h| h.delete(:id) } }).should include( {:suit => "Spades", :rank => "Ace", :value => 14} )
      (result3.map { |hash| hash.tap { |h| h.delete(:id) } }).should include( {:suit => "Spades", :rank => "Ace", :value => 14} )
    end
    
    it "should be empty when field value does not exist" do
      result = Poker.search(suit: "Zpades")
      result.size.should == 0
    end
    
    it "should have fields with correct types" do
      result = Poker.search(suit: "Spades")
      fields = result.first
      fields[:suit].should be_a_kind_of(String)
      fields[:rank].should be_a_kind_of(String)
      fields[:value].should be_a_kind_of(Fixnum)
    end

    it "should find all instances that match query" do
      result = Poker.search(suit: "Clubs")

      # delete id from result, value is nondeterministic unless using mocks
      (result.map { |hash| hash.tap { |h| h.delete(:id) } }).should include( {:suit => "Clubs", :rank => "Jack", :value => 11}, {:suit => "Clubs", :rank => "Queen", :value => 12} )
    end 

    it "should be empty if query field type mismatches" do
      result = Poker.search(rank: "14")
      result.size.should == 0
    end   
  end
end  