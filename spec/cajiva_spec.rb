# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/version'
require_relative '../lib/linear_regression'

describe 'Cajiva' do
  it 'has a version number' do
    expect(::Cajiva::VERSION).not_to be nil
  end
end

describe Cajiva::LinearRegression do
  let(:x_values) { [1, 2, 3, 4, 5] }
  let(:y_values) { [2, 4, 6, 8, 10] }
  let(:regression) { Cajiva::LinearRegression.new(x_values, y_values) }

  it 'calculates slope correctly' do
    expect(regression.slope).to be_within(0.01).of(2.0)
  end

  it 'calculates intercept correctly' do
    expect(regression.intercept).to be_within(0.01).of(0.0)
  end

  it 'calculates R² value' do
    expect(regression.r_squared).to be_within(0.01).of(1.0)
  end

  it 'makes predictions' do
    expect(regression.predict(6)).to be_within(0.1).of(12.0)
  end

  it 'generates equation string' do
    eq = regression.equation
    expect(eq).to include('y =')
    expect(eq).to include('x')
  end
end
