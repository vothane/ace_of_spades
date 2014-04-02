module Query
  class Conditions
    def initialize(&block)
      @fields = []
      block.call(self) unless block.nil?
    end

    def to_search_conditions
      query_strings = []
      arguments = []

      @fields.each do |field|
        # Get the conditions of each field
        query_string, *field_arguments = field.to_query_condition

        # Append them to the rest
        query_strings << query_string
        arguments << field_arguments
      end

      # Build them up into the right format
      full_query_string = query_strings.join(" AND ")
      full_query_string
    end

    def method_missing(name, *args)
      field = Field.new(name)
      @fields << field
      field
    end
  end

  class Field
    attr_reader :name, :operator, :operand

    def initialize(name)
      @name = name
    end

    OPERATOR_MAP = {
      :== => ":",
      :=~ => "~"
    }

    [:==, :=~].each do |operator|
      define_method(operator) do |operand|
        @operator = operator
        if ( operand.instance_of? String )
          operand = "'#{operand}'"
        end
        @operand = operand
      end

      def to_query_condition
        return "#{name}#{OPERATOR_MAP[operator]}#{operand}"
      end
    end
  end
end