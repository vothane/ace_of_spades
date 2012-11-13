require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ace_of_spades' do

  class Joker < ActiveRecord::Base
    ace_of_spades
  end

  context "when included" do
    
    it "should included ace_of_spades searchable method" do
      Joker.should respond_to( :searchable )
    end

  end

end