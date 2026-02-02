# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/json_data_fetcher'
require_relative '../lib/linear_regression'

describe Cajiva::JsonDataFetcher do
  let(:fetcher) { Cajiva::JsonDataFetcher.new }

  it 'fetches temperature data from JSON' do
    x, y = fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
    expect(x.length).to eq(30)
    expect(y.length).to eq(30)
  end

  it 'returns sequential x values' do
    x, _y = fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
    expect(x.first).to eq(1)
    expect(x.last).to eq(30)
  end

  it 'returns temperature values as floats' do
    _x, y = fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
    expect(y.first).to be_a(Float)
    expect(y.first).to be > 20
  end
end

describe 'Integration: Linear Regression with JSON Data' do
  it 'analyzes Tel Aviv June temperature trend' do
    fetcher = Cajiva::JsonDataFetcher.new
    x, y = fetcher.fetch_temperature_data('Tel Aviv', 6, 2024)
    model = Cajiva::LinearRegression.new(x, y)

    expect(model.slope).to be > 0 # Temperature increases
    expect(model.r_squared).to be > 0.8 # Good fit
  end
end
