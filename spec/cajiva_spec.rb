# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/version'

describe 'Cajiva' do
  it 'has a version number' do
    expect(::Cajiva::VERSION).not_to be nil
  end

  it 'displays welcome message' do
    expect { load File.join(__dir__, '..', 'main.rb') }.not_to raise_error
  end
end
