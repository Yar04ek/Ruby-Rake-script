# frozen_string_literal: true

# The DockerManager class provides methods for managing Docker images and containers.
# It allows to download an image, run a container, multiple containers and remove all the containers and images.
# The DockerManager class provides methods for managing Docker images and containers.
# It allows to download an image, run a container, multiple containers and remove all the containers and images.
class DockerManager
  def initialize(data, image_base_name)
    @data = data
    @image_base_name = image_base_name
  end

  def download_image(image_name)
    system("docker pull #{@image_base_name}:#{image_name}")
  end

  def start_container(image_name, version)
    container_name = "my_container_#{version}_#{rand(1..10_000)}"
    system("docker run -d --name #{container_name} -p 80:80 #{@image_base_name}:#{image_name}")
    system("docker exec #{container_name} sudo supervisorctl start ds:example")
  end

  def run_containers
    @data[:versions].each do |version|
      next unless download_image(version)

      @data[:containers].times { start_container(version, version) }
    end
  end

  def remove_containers_and_images
    system('docker kill $(docker ps -q)')
    system('docker rm $(docker ps -a -q)')
    system('docker rmi $(docker images -q)')
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end
end
