# frozen_string_literal: true

require_relative 'docker_manager'
require_relative 'test_data'

namespace :docker do
  desc 'Download Docker image'
  task :run do
    TEST_DATA.each do |data|
      manager = DockerManager.new(data)
      manager.run_containers if data[:download]
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  desc 'Remove Docker container and image'
  task :rmi do
    TEST_DATA.each do |data|
      manager = DockerManager.new(data)
      manager.remove_containers_and_images
    end
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end
end
