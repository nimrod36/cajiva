# frozen_string_literal: true

module Cajiva
  # Fetches temperature data from database and prepares it for regression
  class DataFetcher
    def initialize(database_connection)
      @db = database_connection
    end

    def fetch_temperature_data(city, month, year)
      sql = build_query(city, month, year)
      results = @db.query(sql)
      convert_to_arrays(results)
    end

    private

    def build_query(city, month, year)
      <<~SQL
        SELECT date, hour, temperature
        FROM temperature_readings
        WHERE city = '#{city}'
          AND MONTH(date) = #{month}
          AND YEAR(date) = #{year}
          AND hour = 12
        ORDER BY date ASC
      SQL
    end

    def convert_to_arrays(results)
      x_values = []
      y_values = []

      # IMPORTANT: Use << (append) operator to add elements
      # Do NOT use assignment (=) which would override previous values
      results.each_with_index do |row, index|
        x_values << (index + 1) # Append day to x array
        y_values << row[:temperature].to_f      # Append temperature to y array
      end

      [x_values, y_values]
    end
  end
end
