RAILS_ROOT = File.expand_path(File.dirname(__FILE__))

God.watch do |w|
  w.name = 'fetcher'
  w.dir = RAILS_ROOT
  w.start = "ruby #{RAILS_ROOT}/script/calc_account.rb"
  w.log = "#{RAILS_ROOT}/calculate.log"
  w.keepalive
end
