module Ace
  module Spades
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def ace_of_spades(config = {})

        class << self

          def searchable(options = {})
            
          end
          
        end

        include InstanceMethods
      end
    end

    module InstanceMethods

    end
  end
end

ActiveRecord::Base.send :include, Ace::Spades