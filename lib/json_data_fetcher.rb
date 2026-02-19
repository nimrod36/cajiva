# frozen_string_literal: true

require 'json'
require 'date'

module Cajiva
  # Fetches temperature data from JSON file and prepares it for regression
  class JsonDataFetcher
    def initialize(json_file_path = 'data/temperature_data.json')
      @json_file_path = json_file_path
      @data = load_data
    end

    def fetch_temperature_data(city, month, year)
      filtered = @data['temperature_readings'].select do |record|
        date = Date.parse(record['date'])
        record['city'] == city &&
          date.month == month &&
          date.year == year &&
          record['hour'] == 12
      end

      convert_to_arrays(filtered)
    end

    private

    def load_data
      file_path = File.join(File.dirname(__FILE__), '..', @json_file_path)
      JSON.parse(File.read(file_path))
    end

    def convert_to_arrays(records)
      x_values = []
      y_values = []

      # IMPORTANT: Use << (append) operator to add elements
      # Do NOT use assignment (=) which would override previous values
      records.each_with_index do |record, index|
        x_values << (index + 1) # Append day to x array
        y_values << record['temperature'].to_f  # Append temperature to y array
      end

      [x_values, y_values]
    end
  end
end
