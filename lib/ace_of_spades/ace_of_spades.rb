module Ace
  module Spades
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def ace_of_spades(config = {})

        cattr_accessor :aces_high_server
        cattr_accessor :searchable_block
        
        self.aces_high_server = DRbObject.new_with_uri(config[:server_address])
        
        class << self

          def searchable(options = {}, &block)

            self.searchable_block = block

            after_save :perform_index_tasks
           
            after_destroy :remove_from_index
      
          end

          def search(query, field)
            result = self.aces_high_server.search( query, field )
          end    
          
        end

        include InstanceMethods
      end
    end

    module InstanceMethods

      def text(*fields)
        fields.each do |field|
          self.aces_high_server.index( field, self.send(field) )
        end  
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