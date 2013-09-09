require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "searching" do

  context "when committing to index by saving and then searching on index" do

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