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

      def searchable_fields(*fields)
        fields.each do |field| 
          set_field_to_index(field)
        end  
      end

      def get_column_field_type(field)
        @record.columns_hash[field.to_s].type
      end 
      
      def set_field_to_index(field)
        field_type = get_column_field_type(field)
        @indexer.store_field( field ) 
        @indexer.set_field_type( field, TYPE_MAP[field_type] )
        @indexer.tokenize_text_field( field ) if field_type == :text  
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
