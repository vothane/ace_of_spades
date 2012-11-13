require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ace_of_spades' do

  class Joker < ActiveRecord::Base
    ace_of_spades

    searchable
  end

  context "when included" do
    
    it "should included ace_of_spades searchable method" do
      Joker.should respond_to( :searchable )
    end

  end

  context "when searchable is called on Joker" do
    
    it "should have after_save callback calling perform_index_tasks method" do
      Joker._save_callbacks.select { |cb| cb.kind.eql?( :after ) }
                           .collect( &:filter )
                           .should include( :perform_index_tasks )
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
      joker.save
    end

  end

end