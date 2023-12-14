# frozen_string_literal: true

require 'open3'
# This module is used to handle system commands execution
module SystemCommandExecutor
  def self.run_system_cmd(cmd)
    stdout, stderr, status = Open3.capture3(cmd)
    raise "Command execution failed: #{cmd}. Error: #{stderr}" unless status.success?

    stdout.strip
  end
end

# This class manages Docker images
class DockerImageManager
  extend SystemCommandExecutor

  def initialize(image_name)
    @image_name = image_name
  end

  def download
    SystemCommandExecutor.run_system_cmd("docker pull #{@image_name}")
  end
end

# This class manages Docker containers
class DockerContainerManager
  extend SystemCommandExecutor

  def initialize(container_name, image_name)
    @container_name = container_name
    @image_name = image_name
  end

  def start
    SystemCommandExecutor.run_system_cmd("docker run -d -p 80:80 --name #{@container_name} #{@image_name}")
  end

  def self.stop_all
    SystemCommandExecutor.run_system_cmd('docker kill $(docker ps -q)')
    SystemCommandExecutor.run_system_cmd('docker rm $(docker ps -a -q)')
  end

  def self.remove_all_images
    SystemCommandExecutor.run_system_cmd('docker rmi -f $(docker images -q)')
  end
end

# This class orchestrates the management of containers
class ContainerOrchestrator
  def initialize(data)
    @data = data
  end

  def orchestrate
    @data[:versions].each do |version|
      image_name = "onlyoffice/4testing-documentserver-ee:#{version}"
      image_manager = DockerImageManager.new(image_name)
      image_manager.download if @data[:download]

      @data[:containers].times do
        container_name = generate_container_name(image_name, version)
        container_manager = DockerContainerManager.new(container_name, image_name)
        container_manager.start
      end
    end
  end

  private

  def generate_container_name(image_name, version)
    "#{image_name.split('/').last.gsub(':', '_')}_#{version}_#{rand(1..10_000)}"
  end
end
