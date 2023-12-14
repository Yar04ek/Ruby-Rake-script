# frozen_string_literal: true

require 'open3'
require_relative 'docker_manager'
require_relative 'test_data'

DOCKER_RUN = 'run'
DOCKER_RMI = 'rmi'

namespace :docker do
  desc 'Download Docker image and run containers'
  task DOCKER_RUN do
    TEST_DATA.map do |data|
      orchestrator = ContainerOrchestrator.new(data)
      begin
        orchestrator.orchestrate if data[:download]
        puts 'Containers started successfully'
      rescue StandardError => e
        warn "An error occurred during containers start: #{e.message}"
      end
    end
  end

  desc 'Remove Docker container and image'
  task DOCKER_RMI do
    DockerContainerManager.stop_all
    DockerContainerManager.remove_all_images
    puts 'Containers and images removed successfully'
  rescue StandardError => e
    warn "An error occurred during containers and images removal: #{e.message}"
  end
end
