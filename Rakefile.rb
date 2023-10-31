# Rakefile

require_relative 'test_data'

namespace :docker do
  desc "Download a Docker image and start a container"
  task :pull_and_run_container do
    version = TestData[:version] || 'latest'
    image_name = "onlyoffice/4testing-documentserver-ee:#{version}"


    sh "docker pull #{image_name}"


    sh "docker run -d --name my_container  #{image_name}"
  end

  desc "Remove a Docker image, stopping and deleting the associated container"
  task :remove_image do
    version = TestData[:version] || 'latest'
    image_name = "onlyoffice/4testing-documentserver-ee:#{version}"


    sh "docker stop my_container" rescue nil


    sh "docker rm my_container" rescue nil


    sh "docker rmi #{image_name}"
  end
end
