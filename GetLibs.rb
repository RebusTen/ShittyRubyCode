#!/usr/bin/ruby2.5
require '~/docs/ruby/Libs/Logo.rb'
include Logo

Logo.LogoFull("PoisonousJAM","GetLibs")
puts "\n>>>Enter password if required to set ruby libs as global!"
puts   ">>>Requires Libs folder next to this script!!!"

system('sudo ln -sf ~/docs/ruby/Libs/* /usr/lib/ruby/2.5.0/')

puts "Done!"