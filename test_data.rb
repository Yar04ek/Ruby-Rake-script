# frozen_string_literal: true

# test_data.rb

TEST_DATA = [
  {
    versions: ['8.0.0.15', '7.6.0.31', '7.6.0.29'],
    download: false,
    containers: 0
  },
  {
    versions: ['8.0.0.15'],
    download: true,
    containers: 1
  },
  {
    versions: ['7.6.0.30'],
    download: false,
    containers: 1
  }
].freeze
