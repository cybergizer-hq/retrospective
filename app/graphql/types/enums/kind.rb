# frozen_string_literal: true

module Types
  module Enums
    class Kind < Types::BaseEnum
      description 'All available cards kind'

      value('mad', 'Something mad')
      value('sad', 'Something sad')
      value('glad', 'Something glad')
    end
  end
end
