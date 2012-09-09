#!/usr/bin/env rake

require 'coffee-script'

namespace :assets do
  task :compile do
    File.open(File.join(File.dirname(__FILE__), "public/s3-upload.js"), "w") do |f|
      f << CoffeeScript.compile(File.read(File.join(File.dirname(__FILE__), "s3-upload.coffee")))
    end
  end
end
