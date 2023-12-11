# frozen_string_literal: true

# The DockerManager class provides methods for managing Docker images and containers.
# It allows to download an image, run a container, multiple containers and remove all the containers and images.
# The DockerManager class provides methods for managing Docker images and containers.
# It allows to download an image, run a container, multiple containers and remove all the containers and images.
class DockerManager
  def initialize(data)
    @data = data
  end

  def download_image?(image_name)
    execute_command("docker pull #{image_name}")
  end

  def start_container(image_name, version)
    container_name = generate_container_name(version)
    execute_command("docker run -d --name #{container_name} -p 80:80 #{image_name}")
    start_supervisor
  end

  def run_containers
    @data[:versions].each do |version|
      image_name = "onlyoffice/4testing-documentserver-ee:#{version}"

      next unless download_image?(image_name)

      @data[:containers].times { start_container(image_name, version) }
    end
  end

  def remove_containers_and_images
    execute_command('docker kill $(docker ps -q)')
    execute_command('docker rm $(docker ps -a -q)')
    execute_command('docker rmi $(docker images -q)')
  end

  private

  def generate_container_name(version)
    "my_container_#{version}_#{rand(1..10_000)}"
  end

  def start_supervisor
    container_id = `docker ps -q -l`.strip
    execute_command("sudo docker exec #{container_id} sudo supervisorctl start ds:example")
  end

  def execute_command(command)
    system(command)
  end
end
