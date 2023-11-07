require_relative 'test_data'

namespace :docker do
  desc "Скачать Docker образ"
  task :pull_image do
    version = TestData[:version] || 'latest'
    image_name = "onlyoffice/4testing-documentserver-ee:#{version}"
    ports = TestData[:ports] || 'YOUR_DEFAULT_PORTS' # Замените 'YOUR_DEFAULT_PORTS' на фактическую конфигурацию порта по умолчанию

    sh "docker pull #{image_name}"
    sh "docker run -it -d -p 80:80 --name my_container #{image_name}"
  end

  desc "Удалить Docker контейнер и образ"
  task :remove_container_and_image do
    sh "docker stop my_container"
    sh "docker rm my_container"
    version = TestData[:version] || 'latest'
    image_name = "onlyoffice/4testing-documentserver-ee:#{version}"
    sh "docker rmi #{image_name}"
  end
end
