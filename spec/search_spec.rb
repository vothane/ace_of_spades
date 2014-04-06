require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "searching" do

  context "when committing to index by saving and then searching on index" do

    before :all do
      @card1 = Poker.create(suit: "Hearts",   rank: "King",  value: 13, description: CARD_MAP[:hearts_king])
      @card2 = Poker.create(suit: "Spades",   rank: "Ace",   value: 14, description: CARD_MAP[:spades_ace])
      @card3 = Poker.create(suit: "Diamonds", rank: "Jack",  value: 11, description: CARD_MAP[:diamonds_jack])
      @card4 = Poker.create(suit: "Spades",   rank: "Queen", value: 12, description: CARD_MAP[:spades_queen])
      @card5 = Poker.create(suit: "Clubs",    rank: "Queen", value: 12, description: CARD_MAP[:clubs_queen])
    end

    after :all do
      @card1.destroy
      @card2.destroy
      @card3.destroy
      @card4.destroy
      @card5.destroy
    end

    it "should find by field" do
      hits = Poker.search("Ace")

      hits.size.should == 1

      (hits.map { |hash| hash.tap { |h| h.delete(:id) } }).should include({"description" => CARD_MAP[:spades_ace]})
    end

    it "should delete AR instance attrs in search index when AR instance is destroyed" do
      hits = Poker.search("Jack")

      hits.size.should == 1

      @card3.destroy

      hits = Poker.search("Jack")

      hits.size.should == 0
    end

    it "should find by field and using query DSL" do
      hits = Poker.search do |s|
               s.suit == "Hearts"
            end 
             
      hits.size.should == 1

      (hits.map { |hash| hash.tap { |h| h.delete(:id) } }).should include({"description" => CARD_MAP[:hearts_king]})
    end
  end  
end