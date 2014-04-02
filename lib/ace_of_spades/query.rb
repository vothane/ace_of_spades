module Query
  class Conditions
    def initialize(&block)
      @fields = []
      block.call(self) unless block.nil?
    end

    def to_search_conditions
      query_strings = []
      @fields.each { |field| query_strings << field.to_query_condition }
      query_strings.join(" AND ")
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
        operand = "'#{operand}'" if ( operand.instance_of? String ) 
        @operand = operand
      end

      def to_query_condition
        return "#{name}#{OPERATOR_MAP[operator]}#{operand}"
      end
    end
  end
end