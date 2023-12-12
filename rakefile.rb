# frozen_string_literal: true

require 'open3'
require_relative 'container_manager'
require_relative 'test_data'

DOCKER_RUN = ':run'
DOCKER_RMI = ':rmi'

namespace :docker do
  desc 'Download Docker image and run containers'
  task DOCKER_RUN do
    TEST_DATA.map do |data|
      manager = ContainerManager.new(data)
      begin
        manager.run_containers if data[:download]
        puts 'Containers started successfully'
      rescue StandardError => e
        warn "An error occurred during containers start: #{e.message}"
      end
    end
  end

  desc 'Remove Docker container and image'
  task DOCKER_RMI do
    TEST_DATA.map do |data|
      manager = ContainerManager.new(data)
      begin
        manager.remove_containers_and_images
        puts 'Containers and images removed successfully'
      rescue StandardError => e
        warn "An error occurred during containers and images removal: #{e.message}"
      end
    end
  end
end
