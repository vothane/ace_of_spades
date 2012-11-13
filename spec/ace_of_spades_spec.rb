require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ace_of_spades' do

  class Joker < ActiveRecord::Base
    acts_of_spades
  end

  context "when included" do
    
    it "should included acts_as_hyperactive alias methods" do
      Joker.should respond_to( :searchable )
    end

  end
  
end