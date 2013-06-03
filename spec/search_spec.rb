require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "searching" do
  context "when committing to index by saving and then searching on index" do

    class Poker < ActiveRecord::Base
      ace_of_spades({:server_address => 'druby://localhost:12345'})

      searchable do
        text :suit, :rank, :value, :description
      end
    end

    before :all do
      card1 = Poker.create(suit: "Hearts",   rank: "King",  value: 13, description: CARD_MAP[:hearts_king])
      card2 = Poker.create(suit: "Spades",   rank: "Ace",   value: 14, description: CARD_MAP[:spades_ace])
      card3 = Poker.create(suit: "Diamonds", rank: "Jack",  value: 11, description: CARD_MAP[:diamonds_jack])
      card4 = Poker.create(suit: "Spades",   rank: "Queen", value: 12, description: CARD_MAP[:spades_queen])
      card5 = Poker.create(suit: "Clubs",    rank: "Queen", value: 12, description: CARD_MAP[:clubs_queen])
    end

    it "should find by field" do
      result1 = Poker.search(rank: "Ace")
      result2 = Poker.search(value: 14)

      result1.size.should == 1
      result2.size.should == 1

      # delete id from result, value is nondeterministic unless using mocks
      (result1.map { |hash| hash.tap { |h| h.delete(:id) } }).should include({:suit => "Spades", :rank => "Ace", :value => 14, :description => CARD_MAP[:spades_ace]})
      (result2.map { |hash| hash.tap { |h| h.delete(:id) } }).should include({:suit => "Spades", :rank => "Ace", :value => 14, :description => CARD_MAP[:spades_ace]})
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
      result = Poker.search(suit: "Spades")

      # delete id from result, value is nondeterministic unless using mocks
      (result.map { |hash| hash.tap { |h| h.delete(:id) } }).should include({:suit => "Spades", :rank => "Ace", :value => 14, :description => CARD_MAP[:spades_ace]},
                                                                            {:suit => "Spades", :rank => "Queen", :value => 12, :description => CARD_MAP[:spades_queen]})
    end

    it "should be empty if query field type mismatches" do
      result = Poker.search(rank: "14")
      result.size.should == 0
    end

    it "should do find by token on tokenized text field" do
      result1 = Poker.search("description:'mustache'")
      result2 = Poker.search("description:'death'")

      (result1.map { |hash| hash.tap { |h| h.delete(:id) } }).should include({:suit => "Hearts", :rank => "King", :value => 13, :description => CARD_MAP[:hearts_king]})
      
      (result2.map { |hash| hash.tap { |h| h.delete(:id) } }).should include({:suit => "Spades", :rank => "Ace", :value => 14, :description => CARD_MAP[:spades_ace]})
    end

    it "should do fuzzy search on tokenized text field" do
      result = Poker.search("description:laugh*")

      (result.map { |hash| hash.tap { |h| h.delete(:id) } }).should include({:suit => "Diamonds", :rank => "Jack", :value => 11, :description => CARD_MAP[:diamonds_jack]})
    end
  end  
end

CARD_MAP = {
  hearts_king: "The King of Hearts is the only King with no mustache, and is also typically shown with a sword behind his head, making him appear to be stabbing himself.",
  spades_ace: "The Ace of Spades, unique in its large, ornate spade, is sometimes said to be the death card, and in some games is used as a trump card.",
  diamonds_jack: "The Jack of Diamonds is sometimes known as laughing boy.",
  spades_queen: "The Queen of Spades usually holds a scepter and is sometimes known as 'the bedpost Queen', though more often she is called 'Black Lady'.",
  clubs_queen: "In many decks, the Queen of Clubs holds a flower. She is thus known as the 'flower Queen'."
}