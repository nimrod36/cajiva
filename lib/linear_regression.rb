# frozen_string_literal: true

module Cajiva
  # Performs linear regression analysis on data points
  class LinearRegression
    attr_reader :slope, :intercept, :r_squared

    def initialize(x_values, y_values)
      @x_values = x_values
      @y_values = y_values
      @slope = 0
      @intercept = 0
      @r_squared = 0
      calculate_regression
    end

    def predict(input_x)
      @slope * input_x + @intercept
    end

    def equation
      sign = @intercept >= 0 ? '+' : '-'
      "y = #{@slope.round(4)}x #{sign} #{@intercept.abs.round(4)}"
    end

    private

    def calculate_regression
      n = @x_values.length
      sum_x = @x_values.sum
      sum_y = @y_values.sum
      sum_xy = @x_values.zip(@y_values).map { |val_x, val_y| val_x * val_y }.sum
      sum_x2 = @x_values.map { |val_x| val_x**2 }.sum
      denominator = (n * sum_x2 - sum_x**2).to_f
      @slope = (n * sum_xy - sum_x * sum_y) / denominator
      @intercept = (sum_y - @slope * sum_x) / n.to_f
      calculate_r_squared
    end

    def calculate_r_squared
      mean_y = @y_values.sum.to_f / @y_values.length
      ss_tot = @y_values.map { |y| (y - mean_y)**2 }.sum
      ss_res = @y_values.map.with_index do |y, idx|
        (y - predict(@x_values[idx]))**2
      end.sum
      @r_squared = 1 - (ss_res / ss_tot)
    end
  end
end
