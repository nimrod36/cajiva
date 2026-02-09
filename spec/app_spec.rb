# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'
require_relative '../app'

describe 'Cajiva Web Application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'GET /api/data' do
    it 'returns temperature data and regression' do
      get '/api/data'
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('application/json')

      data = JSON.parse(last_response.body)
      expect(data).to have_key('actual')
      expect(data).to have_key('regression')
      expect(data).to have_key('equation')
      expect(data).to have_key('r_squared')
      expect(data).to have_key('slope')
      expect(data).to have_key('intercept')
      expect(data['actual'].length).to be > 0
    end
  end

  describe 'POST /api/calculate' do
    it 'calculates regression for provided data' do
      test_data = {
        data: [
          { x: 1, y: 2 },
          { x: 2, y: 4 },
          { x: 3, y: 6 }
        ]
      }

      post '/api/calculate', test_data.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response).to be_ok
      expect(last_response.content_type).to include('application/json')

      data = JSON.parse(last_response.body)
      expect(data).to have_key('actual')
      expect(data).to have_key('regression')
      expect(data).to have_key('equation')
      expect(data['actual'].length).to eq(3)
      expect(data['slope']).to be_within(0.01).of(2.0)
      expect(data['intercept']).to be_within(0.01).of(0.0)
    end

    it 'calculates regression with two data points' do
      test_data = {
        data: [
          { x: 1, y: 10 },
          { x: 2, y: 20 }
        ]
      }

      post '/api/calculate', test_data.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response).to be_ok

      data = JSON.parse(last_response.body)
      expect(data['actual'].length).to eq(2)
      expect(data['slope']).to be_within(0.01).of(10.0)
    end

    it 'calculates regression with decimal values' do
      test_data = {
        data: [
          { x: 1.5, y: 28.5 },
          { x: 2.3, y: 29.1 },
          { x: 15.8, y: 36.0 }
        ]
      }

      post '/api/calculate', test_data.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response).to be_ok

      data = JSON.parse(last_response.body)
      expect(data['actual'].length).to eq(3)
      expect(data).to have_key('slope')
      expect(data).to have_key('intercept')
      expect(data).to have_key('r_squared')
    end
  end

  describe 'GET /' do
    it 'serves the index page' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Cajiva')
      expect(last_response.body).to include('Add Data Point')
      expect(last_response.body).to include('Recalculate Regression Line')
    end
  end
end
