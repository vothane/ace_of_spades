require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ace_of_spades' do

  class Joker < ActiveRecord::Base
    ace_of_spades

    searchable do 
      text :name, :occupation
    end
  end

  context "when included" do

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

    it 'should run the proper callbacks to handle indexing' do
      joker = Joker.new
      joker.should_receive(:text).with(:name, :occupation)
      Aces::High::Indexer.should_receive(:index_text_field)
      joker.save
    end

  end

  context 'after_destroy' do
    it 'should run the proper callbacks' do
      project = Joker.new
      project.should_receive(:remove_from_index)
      project.run_callbacks(:destroy) { true }
    end
  end

end