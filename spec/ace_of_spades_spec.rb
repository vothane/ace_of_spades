require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ace_of_spades' do

  context "when included by calling ace_of_spades on class" do

    it "should included ace_of_spades searchable method" do
      Joker.should respond_to( :searchable )
    end
    
    it "should included ace_of_spades searchable_fields instance method" do
      joker = Joker.new(suit: "Spades", rank: "Queen", value: 12, description: CARD_MAP[:spades_queen])
      joker.should respond_to( :searchable_fields )
    end
    
    it "should be an instance of DRbObject" do
      Joker.aces_high_server.should be_a( DRb::DRbObject )
    end

  end

  context "when searchable is called on Joker" do
    
    it "should have after_save callback calling perform_index_tasks method" do
      Joker._save_callbacks.select { |cb| cb.kind.eql?( :after ) }
                           .collect( &:filter )
                           .should include( :perform_index_tasks )
    end
    
    it "should have after_destroy callback calling remove_from_index method" do
      Joker._destroy_callbacks.select { |cb| cb.kind.eql?( :after ) }
                              .collect( &:filter )
                              .should include( :remove_from_index )
    end
    
  end

  context "when saving an instance of Joker" do

    let(:joker) do
      mock_model("Joker", suit: "Hearts", 
                          rank: "King",
                          value: 13,
                          description: CARD_MAP[:hearts_king]
                ).as_new_record.as_null_object
    end

    it "should call :after_save callback" do
      joker.should_receive( :save ).and_return( true )
      joker.should respond_to( :after_save )
      joker.save
    end

  end

  context "when calling :after_save callback" do

    it 'should run the proper callbacks' do
      joker = Joker.new(suit: "Spades", rank: "Queen", value: 12, description: CARD_MAP[:spades_queen])
      joker.should_receive(:perform_index_tasks)
      joker.run_callbacks(:save) { true } 
    end

    it 'should access attributes defined in searchable block' do
      joker = Joker.new(suit: "Diamonds", rank: "Jack", value: 11, description: CARD_MAP[:diamonds_jack])
      Joker.aces_high_server.should_receive(:index).with(:id => "", "suit" => "Diamonds", "rank" => "Jack", 
                                                         "value" => "11", "description" => CARD_MAP[:diamonds_jack])
      joker.run_callbacks(:save) { true }
    end

  end

  context "when calling :after_destroy callback" do
    it 'should run the proper callbacks' do
      joker = Joker.new(suit: "Clubs", rank: "Queen", value: 12, description: CARD_MAP[:clubs_queen])
      joker.should_receive(:remove_from_index)
      joker.run_callbacks(:destroy) { true }
    end
  end

  context "when searching" do

    let(:joker) do
      mock_model("Joker", suit: "Spades", 
                          rank: "Ace",
                          value: 14,
                          description: CARD_MAP[:spades_ace]
                ).as_new_record.as_null_object
    end

    it "should do find" do
      joker.save
      query = "rank:'Ace'"
      field = :suit
      Joker.aces_high_server.should_receive(:search).with(query).and_return("Spades")
      result = Joker.search(query)
      result.should == "Spades" 
    end

  end

  context "when saving an instance of Joker" do

    let(:joker) do
      mock_model("Joker", suit: "Haarts", 
                          rank: "King",
                          value: 13,
                          description: CARD_MAP[:hearts_king]
                ).as_new_record.as_null_object
    end

    it "should call :after_destroy callback" do
      joker.save
      joker.should_receive( :destroy ).and_return( true )
      joker.should respond_to( :after_destroy )
      joker.destroy
    end

  end

  context "when calling :after_destroy callback" do

    it 'should run the proper callbacks' do
      joker = Joker.new(suit: "Diamonds", rank: "Jack", value: 11, description: CARD_MAP[:diamonds_jack])
      joker.save
      joker.should_receive(:remove_from_index)
      joker.run_callbacks(:destroy) { true } 
    end

    it 'should access attributes defined in searchable block' do
      joker = Joker.new(suit: "Spades", rank: "Queen", value: 12, description: CARD_MAP[:spades_queen])
      joker.save
      Joker.aces_high_server.should_receive(:remove_from_index).with("2")
      joker.run_callbacks(:destroy) { true }
    end

  end

end