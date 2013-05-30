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
      card1 = Poker.new(suit: "Hearts",   rank: "King")
      card2 = Poker.new(suit: "Spades",   rank: "Ace")
      card3 = Poker.new(suit: "Clubs",    rank: "Jack")
      card4 = Poker.new(suit: "Diamonds", rank: "Three")
      card5 = Poker.new(suit: "Clubs",    rank: "Ace")

      card1.save
      card2.save
      card3.save
      card4.save
      card5.save

      result = Poker.search(suit: "Spades")
      result.size.should == 1
      result.should include( {:id => "2", :suit => "Spades", :rank => "Ace"} )
    end
  end
end  