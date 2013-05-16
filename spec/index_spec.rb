require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ace_of_spades' do

  class Poker < ActiveRecord::Base
    ace_of_spades( {:server_address => 'druby://localhost:12345'} )

    searchable do 
      text :suit, :rank
    end
  end

  context "when committing to index by saving and then searching on index" do
    
    it "should find by tag" do
      poker = Poker.new(suit: "Hearts", rank: "King")
      poker.save
      result = Poker.search(suit: "Hearts")
binding.pry      
      result.size.should == 1
      #doc = result[0]
      #doc[:suit].should == 'Hearts'
      #doc[:rank].should == 'King'
    end
  end
end  