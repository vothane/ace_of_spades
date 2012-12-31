module Ace
  module Spades
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def ace_of_spades(config = {})
        
        cattr_accessor :searchable_block

        class << self

          def searchable(options = {}, &block) 

            self.searchable_block = block

            Aces::High.indexer( self, &block )

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
        block = self.searchable_block 
        self.instance_eval(&block)
      end

      def remove_from_index
        puts "ok"
      end

    end
  end
end

ActiveRecord::Base.send :include, Ace::Spades