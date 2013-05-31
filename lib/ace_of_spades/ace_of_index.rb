module Ace
  module Spades
    module Indexable
      def self.set_field_stores(record, indexer, &block)
        index_store = StoreIndex.new(record, indexer)
        index_store.instance_eval(&block)
      end
    end

    class StoreIndex

      def initialize(record, indexer)
        @indexer = indexer
        @record  = record
      end

      def text(*fields)
        fields.each do |field| 
          @indexer.store_field( field ) 
          @indexer.set_field_type( field, TYPE_MAP[@record.columns_hash[field.to_s].type] )
        end  
      end

      TYPE_MAP = {
        :binary      => "String",
        :boolean     => "String",
        :date        => "Date",
        :datetime    => "Date",
        :decimal     => "Float",
        :float       => "Float",
        :integer     => "Fixnum",
        :primary_key => "Fixnum",
        :string      => "String",
        :text        => "String",
        :time        => "Date",
        :timestamp   => "Date"
      }

    end  
  end
end
