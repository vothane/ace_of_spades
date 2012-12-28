require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ace_of_spades' do

  class Joker < ActiveRecord::Base
    ace_of_spades

    searchable do 
      text :name, :occupation
      integer :rank, :suit
    end  
  end

  context "when included" do

    let(:joker) do
      mock_model("Joker", :name       => "John Gray", 
                          :occupation => "Neurotic Megalomaniac"
                ).as_new_record.as_null_object
    end
    
    it "should included ace_of_spades searchable method" do
      Joker.should respond_to( :searchable )
    end
    
    it "should included ace_of_spades text instance method" do
      joker.should respond_to( :text )
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

    it "should include Aces::High module for indexing" do
      Aces::High.should respond_to( :indexer )
    end

  end

  context "when saving an instance of Joker" do

    let(:joker) do
      mock_model("Joker", :name       => "John Gray", 
                          :occupation => "Neurotic Megalomaniac"
                ).as_new_record.as_null_object
    end

    it "should do indexing to lucene via DRb" do
      joker.should_receive( :save ).and_return( true )
      joker.should respond_to( :after_save )
      joker.should_receive( :text ).with( :name, :occupation )
      joker.save
    end

  end

end