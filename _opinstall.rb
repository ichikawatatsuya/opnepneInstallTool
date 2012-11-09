#!/usr/local/bin/ruby
# coding: utf-8

require 'optparse'

dirName = File.basename(Dir::pwd)
if !File.exist?('symfony')
  abort ('OpnePNEフォルダでは無いようなので終了')
end

opt = OptionParser.new
OPT = {}
OPT[:d] = "mysql"
OPT[:u] = "root"
OPT[:p] = ""
OPT[:h] = "localhost"
OPT[:port] = ""
OPT[:n] = dirName
OPT[:s] = ""


begin
  opt.on('-d [VAL]', 'DBMS of -d')                {|v| OPT[:d] = v}
  opt.on('-u [VAL]', 'Database username of -u')   {|v| OPT[:u] = v}
  opt.on('-p [VAL]', 'Database password of -p')   {|v| OPT[:p] = v}
  opt.on('-h [VAL]', 'Database hostname pf -h')   {|v| OPT[:h] = v}
  opt.on('--port [VAL]', 'port number of --port') {|v| OPT[:port] = v}
  opt.on('-n [VAL]', 'Database name of -n')       {|v| OPT[:n] = v}
  opt.on('-s [VAL]', 'Database socket of -s')     {|v| OPT[:s] = v}

  argv = opt.parse(ARGV)

  OPT[:n] = OPT[:n].gsub('.', '_')
  OPT[:n] = OPT[:n].gsub('-', '_')

  puts "DBMS              : #{OPT[:d]}"
  puts "Database username : #{OPT[:u]}"
  puts "Database password : #{OPT[:p]}"
  puts "Database hostname : #{OPT[:h]}"
  puts "port number       : #{OPT[:port]}"
  puts "Database name     : #{OPT[:n]}"
  puts "Database socket   : #{OPT[:s]}"
  print 'インストールしますか？ y/n :'
  answer = STDIN.gets.chomp
  exit unless answer == 'y'

  IO.popen('php symfony openpne:install', 'r+') { |io|
    io.puts(OPT[:d])
    io.puts(OPT[:u])
    io.puts(OPT[:p])
    io.puts(OPT[:h])
    io.puts(OPT[:port])
    OPT[:n] != '' ? io.puts(OPT[:n]) : io.puts(dirName)
    io.puts(OPT[:s])
    io.puts('y')
    io.each{ |line|
      puts line
    }
  }
rescue
  raise $!.message + $@.to_s + 'ダメでした'
else
  puts 'インストール正常終了'
end
