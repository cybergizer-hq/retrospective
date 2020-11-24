# frozen_string_literal: true

module Boards
  class Suggestions
    attr_reader :query_string

    def initialize(str)
      @query_string = str
    end

    def call
      {
        users: fitting_users(query_string).pluck(:email),
        teams: fitting_teams(query_string).pluck(:name)
      }
    end

    def fitting_users(str)
      User.where('email ILIKE ?', "#{str}%")
          .or(User.where('nickname ILIKE ?', "#{str}%"))
          .or(User.where('uid LIKE ?', "#{str}%")).limit(10)
    end

    def fitting_teams(str)
      Team.where('lower(name) ILIKE ?', "#{str}%")
    end
  end
end
