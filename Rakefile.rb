require_relative 'test_data'

namespace :docker do
  desc "Download Docker image"
  task :pull_image do
    version = ENV.fetch('DOCKER_IMAGE_VERSION', 'latest')
    image_name = "onlyoffice/4testing-documentserver-ee:#{version}"

    sh "docker pull #{image_name}"
    sh "docker run -it -d -p 80:80 --name my_container #{image_name}"
  end

  desc "Remove Docker container and image"
  task :remove_container_and_image do
    sh "docker stop my_container"
    sh "docker rm my_container"
    version = ENV.fetch('DOCKER_IMAGE_VERSION', 'latest')
    image_name = "onlyoffice/4testing-documentserver-ee:#{version}"
    sh "docker rmi #{image_name}"
  end
end
