# frozen_string_literal: true

# rails runner db/update_csv_from_datagouv.rb

require 'fileutils'
require 'open-uri'
require 'zip'


data_folder = Rails.root.join("db/data")

puts "url from https://www.data.gouv.fr/fr/datasets/horaires-des-lignes-ter-sncf/ (click on preview)"
print "> "
url = gets.chomp


puts "download.."
open('data.zip', 'wb') do |file|
  file << open(url).read
end

Zip::File.open("data.zip") do |zipfile|
  zipfile.each do |file|
    fpath = File.join(data_folder, file.name.gsub('txt', 'csv'))
    zipfile.extract(file, fpath)
  end
end


puts "delete data.zip"
File.delete('data.zip') if File.exist? 'data.zip'


file_path = File.join(data_folder, 'stop_times.csv')
content = File.read(file_path)
content.gsub!(',24:', ',00:')
content.gsub!(',25:', ',01:')
content.gsub!(',26:', ',02:')
content.gsub!(',27:', ',03:')
content.gsub!(',28:', ',04:')
content.gsub!(',29:', ',05:')

File.open(file_path, 'w') do |out|
  out << content
end
