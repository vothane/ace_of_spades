class Querythmic < Hash
  attr_accessor :or_querythmic, :and_querythmic
 
  def initialize(values)
    values.each { |key,value| add(key, *value) }
    @or_querythmic = nil
    @and_querythmic = nil
    super
  end

  def add(field, value)
    self[field] = "'#{value}'"
  end

  def or(querythmic)
    _self = self

    while _self.or_querythmic != nil
      break if _self == querythmic
      _self = _self.or_querythmic
    end

    _self.or_querythmic = querythmic
    return self
  end

  def and(querythmic)
    _self = self

    while _self.and_querythmic != nil
      break if _self == querythmic
      _self = _self.and_querythmic
    end
    _self.and_querythmic = querythmic
    return self
  end

  def to_search_string
    query = []

    self.each do |field, value|
      query << "#{field}:#{value}"
    end

    query = '(' + query.join(' AND ') + ')'

    if or_querythmic
      or_query = or_querythmic.to_search_string
      query = "(#{query} OR #{or_query})"
    end

    if and_querythmic
      and_query = and_querythmic.to_search_string
      query = "(#{query} AND #{and_query})"
    end

    return query
  end
end
