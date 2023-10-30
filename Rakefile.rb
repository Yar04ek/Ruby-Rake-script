# Rakefile

require_relative 'test_data' # Импортируем файл с тестовыми данными

namespace :docker do
  desc "Скачать Docker образ"
  task :pull_image do
    version = TestData[:version] || 'latest'
    image_name = "onlyoffice/4testing-documentserver-ee:#{version}"
    sh "docker pull #{image_name}"
  end

  desc "Удалить Docker образ"
  task :remove_image do
    version = TestData[:version] || 'latest'
    image_name = "onlyoffice/4testing-documentserver-ee:#{version}"
    sh "docker rmi #{image_name}"
  end
end
