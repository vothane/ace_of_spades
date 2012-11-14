module Ace
  module Spades
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def ace_of_spades(config = {})

        class << self

          def searchable(options = {}, &block)
            after_save :perform_index_tasks
          end
          
        end

        include InstanceMethods
      end
    end

    module InstanceMethods

      private

      def perform_index_tasks
        puts "ok"
      end

    end
  end
end

ActiveRecord::Base.send :include, Ace::Spades