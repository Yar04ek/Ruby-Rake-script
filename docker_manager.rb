# frozen_string_literal: true

require 'open3'
# The ContainerManager class supports Docker image operations,
# such as downloading images, starting containers and removing containers and images.
class ContainerManager
  DOCKER_KILL_CMD = 'docker kill $(docker ps -q)'
  DOCKER_RM_CMD = 'docker rm $(docker ps -a -q)'
  DOCKER_RMI_CMD = 'docker rmi $(docker images -q)'

  def initialize(data)
    @data = data
  end

  def download_image
    image_name = @data[:image_name]
    run_system_cmd("docker pull #{image_name}")
  end

  def start_container(version)
    image_name = @data[:image_name]
    container_name = "#{image_name}_#{version}_#{rand(1..10_000)}"
    run_system_cmd("docker run -d --name #{container_name} -p 80:80 #{image_name}")
  end

  def run_containers
    @data[:versions].each do |version|
      next unless download_image

      @data[:containers].times { start_container(version) }
    end
  end

  def remove_containers_and_images
    run_system_cmd(DOCKER_KILL_CMD)
    run_system_cmd(DOCKER_RM_CMD)
    run_system_cmd(DOCKER_RMI_CMD)
  end

  def run_system_cmd(cmd)
    stdout, stderr, status = Open3.capture3(cmd)
    raise "Failed executing command: #{cmd}. Error: #{stderr}" unless status.success?

    stdout.strip
  end
end
