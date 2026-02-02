# frozen_string_literal: true

require 'mysql2'

module Cajiva
  # Handles MySQL database connections for the application
  class DatabaseConnection
    attr_reader :connection

    def initialize(host: 'localhost', user: 'root', password: '', database: 'cajiva')
      @connection = Mysql2::Client.new(
        host: host,
        username: user,
        password: password,
        database: database
      )
    end

    def query(sql)
      @connection.query(sql, symbolize_keys: true)
    end

    def close
      @connection.close
    end
  end
end
