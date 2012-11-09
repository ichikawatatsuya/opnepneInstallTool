#!/usr/local/bin/ruby
# coding: utf-8

require 'optparse'
require 'open-uri'

def save_file(url)
  result = `git clone #{url}`
  p result
end

opt = OptionParser.new
OPT = {}
OPT[:d] = "OpenPNE3"
OPT[:c] = nil
OPT[:b] = nil
OPT[:r] = "https://github.com/openpne/OpenPNE3.git"
OPT[:i] = nil

begin
  opt.on('-d [VAL]', 'directory name of -d') {|v| OPT[:d] = v}
  opt.on('-c [VAL]', 'commit of -c')         {|v| OPT[:c] = v}
  opt.on('-b [VAL]', 'branch of -b')         {|v| OPT[:b] = v}
  opt.on('-r [VAL]', 'repository of -r')     {|v| OPT[:r] = v}
  opt.on('-i', 'If you run the installation, please specify. Please put in the same directory as the "opinstall.ry" file.') {|v| OPT[:i] = v}

  argv = opt.parse(ARGV)

  puts "dirName    : #{OPT[:d]}"
  puts "commit     : #{OPT[:c]}"
  puts "branch     : #{OPT[:b]}"
  puts "repository : #{OPT[:r]}"
  puts (OPT[:i] != nil) ? "install" : "do not install"
  print "セットアップしますか？ y/n :"
  answer = STDIN.gets.chomp
  exit unless answer == 'y'

  save_file(OPT[:r])

  #dirName = 'OpenPNE3'
  if OPT[:d] != "OpenPNE3"
    `mv OpenPNE3 #{OPT[:d]}`
    #dirName = OPT[:d]
  end

  #設定ファイルのコピー
  `cd #{OPT[:d]}; cp config/ProjectConfiguration.class.php.sample config/ProjectConfiguration.class.php`
  `cd #{OPT[:d]}; cp config/OpenPNE.yml.sample config/OpenPNE.yml`

  #htaccessの編集
  f = File.open("#{OPT[:d]}/web/.htaccess")
  buffer = f.read();
  buffer.gsub!('#RewriteBase', 'RewriteBase');

  f=File.open("#{OPT[:d]}/web/.htaccess",'w')
  f.write(buffer)
  f.close()

  #branch or commit切り替え
  if OPT[:c] && OPT[:b]
    OPT[:b] = nil
  end

  if OPT[:c]
    p `cd #{OPT[:d]}; git checkout -b #{OPT[:c]}`
  end

  if OPT[:b]
    p `cd #{OPT[:d]}; git checkout -b #{OPT[:b]}`
  end

rescue
  raise $!.message + $@.to_s + 'ダメでした'
else
  puts 'セットアップ正常終了'

  if OPT[:i]
    IO.popen("cd #{OPT[:d]}; ../_opinstall.rb", "r+") {|io|
      io.puts('y')
      io.each { |line|
        puts line
      }
    }
  end
end
