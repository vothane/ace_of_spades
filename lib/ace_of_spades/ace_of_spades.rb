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

            Ace::Spades::Indexable.set_field_stores( self, self.aces_high_server, &block )

            after_save :perform_index_tasks
           
            after_destroy :remove_from_index
      
          end

          def search(query)
            self.aces_high_server.search( query )
          end 

          def clear_index
            self.aces_high_server.clear_index
          end     
          
        end

        include InstanceMethods
      end
    end

    module InstanceMethods

      def searchable_fields(*fields)
        @index_fields = [] if @index_fields.nil?
        index_data = {id: (self.send(:id)).to_s}
        fields.each do |field|
          @index_fields << field unless @index_fields.include? field
          index_data[field.to_s] = (self.send(field)).to_s 
        end         
        self.aces_high_server.index(index_data)
        self.aces_high_server.commit_to_index 
      end

      private

      def perform_index_tasks
        block = self.searchable_block         
        self.instance_eval(&block)
      end

      def remove_from_index
        @index_fields.each do |index_field|
          self.aces_high_server.remove_from_index( index_field.to_s, self.send(index_field) )
        end
      end

    end
  end
end

ActiveRecord::Base.send :include, Ace::Spades