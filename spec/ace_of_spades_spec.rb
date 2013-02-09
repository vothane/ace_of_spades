require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ace_of_spades' do

  class Joker < ActiveRecord::Base
    ace_of_spades( {:server_address => 'druby://localhost:12345'} )

    searchable do 
      text :name, :occupation
    end
  end

  after(:all) do
    puts "\e[32mYes, shit code is my trade. I am a shit coder. My name is John Gray. I architect, code, and ship shit.\e[0m"
  end

  context "when included by calling ace_of_spades on class" do

    let(:joker) do
      mock_model("Joker", :name       => "John Gray", 
                          :occupation => "Rubyist Preeminence Pretender"
                ).as_new_record.as_null_object
    end
    
    it "should included ace_of_spades searchable method" do
      Joker.should respond_to( :searchable )
    end
    
    it "should included ace_of_spades text instance method" do
      joker.should respond_to( :text )
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
      mock_model("Joker", :name       => "John Gray", 
                          :occupation => "Neurotic Megalomaniac"
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
      joker = Joker.new(:name => "John Gray", :occupation => "Tech Lead Dweeb")
      joker.should_receive(:perform_index_tasks)
      joker.run_callbacks(:save) { true } 
    end

    it 'should access attributes defined in searchable block' do
      joker = Joker.new(:name => "John Gray", :occupation => "Analysis Paralysis Rails Developer")
      Joker.aces_high_server.should_receive(:index).with(:name, "John Gray")
      Joker.aces_high_server.should_receive(:index).with(:occupation, "Analysis Paralysis Rails Developer")
      joker.run_callbacks(:save) { true }
    end

  end

  context "when calling :after_destroy callback" do
    it 'should run the proper callbacks' do
      joker = Joker.new(:name => "John Gray", :occupation => "Rails Choke Artist")
      joker.should_receive(:remove_from_index)
      joker.run_callbacks(:destroy) { true }
    end
  end

  context "when searching" do

    let(:joker) do
      mock_model("Joker", :name       => "John Gray", 
                          :occupation => "Shit Code Alchemist"
                ).as_new_record.as_null_object
    end

    it "should do find" do
      joker.save
      query = "occupation:'Shit Code Alchemist'"
      field = :name
      Joker.aces_high_server.should_receive(:search).with(query, field).and_return("John Gray")
      result = Joker.search(query, field)
      result.should == "John Gray" 
    end

  end

  context "when saving an instance of Joker" do

    let(:joker) do
      mock_model("Joker", :name       => "John Gray", 
                          :occupation => "Caricature of Caligula"
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
      joker = Joker.new(:name => "John Gray", :occupation => "'Gloom & Doom' of the IT Room")
      joker.save
      joker.should_receive(:remove_from_index)
      joker.run_callbacks(:destroy) { true } 
    end

    it 'should access atributes defined in searchable block' do
      joker = Joker.new(:name => "John Gray", :occupation => "'Sack of Shit' Hack")
      joker.save
      Joker.aces_high_server.should_receive(:remove_from_index).with(:name, "John Gray")
      Joker.aces_high_server.should_receive(:remove_from_index).with(:occupation, "'Sack of Shit' Hack")
      joker.run_callbacks(:destroy) { true }
    end

  end

end