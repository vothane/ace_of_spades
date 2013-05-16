module Ace
  module Spades
    module Indexable
      def self.set_field_stores(indexer, &block)
        index_store = StoreIndex.new(indexer)
        index_store.instance_eval(&block)
      end
    end

    class StoreIndex

      def initialize(indexer)
        @indexer = indexer
      end

      def text(*fields)
        fields.each { |field| @indexer.store_field( field ) }
      end

    end  
  end
end


