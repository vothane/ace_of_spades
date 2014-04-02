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

          def search(query)
            self.aces_high_server.search( query )
          end 

          def clear_index
            self.aces_high_server.clear_index
          end 

          def removed_from_index?(id)
            self.aces_high_server.removed_from_index?( id )
          end    
          
        end

        include InstanceMethods
      end
    end

    module InstanceMethods

      def searchable_fields(*fields)
        hashify_fields( fields )
      end

      private

      def hashify_fields( fields )
        index_data = {id: (self.send(:id)).to_s}
        fields.each do |field|
          index_data[field.to_s] = (self.send(field)).to_s 
        end  
        index_data       
      end

      def perform_index_tasks
        block = self.searchable_block         
        data = self.instance_eval(&block)
        self.aces_high_server.index( data )
      end

      def remove_from_index
        self.aces_high_server.remove_from_index( self.send(:id).to_s )
      end
    end
  end
end

ActiveRecord::Base.send :include, Ace::Spades