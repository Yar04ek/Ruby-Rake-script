# frozen_string_literal: true

require_relative 'test_data'

def download_image(image_name)
  system("docker pull #{image_name}")
end

def start_container(image_name, version)
  container_name = "my_container_#{version}_#{rand(1..10_000)}"
  system("docker run -d --name #{container_name} -p 80:80 #{image_name}")
  container_id = `docker ps -q -l`.strip
  system("sudo docker exec #{container_id} sudo supervisorctl start ds:example")
end

def run_containers(data)
  data[:versions].each do |version|
    image_name = "onlyoffice/4testing-documentserver-ee:#{version}"
    next unless download_image(image_name)

    data[:containers].times { start_container(image_name, version) }
  end
end

namespace :docker do
  desc 'Download Docker image'
  task :run do
    TEST_DATA.each { |data| run_containers(data) if data[:download] }
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end

  desc 'Remove Docker container and image'
  task :rmi do
    system('docker kill $(docker ps -q)')
    system('docker rm $(docker ps -a -q)')
    system('docker rmi $(docker images -q)')
  rescue StandardError => e
    puts "An error occurred: #{e.message}"
  end
end
