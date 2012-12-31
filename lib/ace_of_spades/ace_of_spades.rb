module Ace
  module Spades
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def ace_of_spades(config = {})
        
        cattr_accessor :search_block

        class << self

          def searchable(options = {}, &blk) 

            self.search_block = blk
            binding.pry
            Aces::High.indexer( self, &blk )

            after_save :perform_index_tasks
           
            after_destroy :remove_from_index
      
          end
          
        end

        include InstanceMethods
      end
    end

    module InstanceMethods

      def text(*args)
        
      end  

      private

      def perform_index_tasks
        blk = self.class.instance_variable_get(:@search_block)
        binding.pry
        self.instance_eval(&blk)
      end

      def remove_from_index
        puts "ok"
      end

    end
  end
end

ActiveRecord::Base.send :include, Ace::Spades