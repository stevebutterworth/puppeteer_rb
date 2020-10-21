require "rb-readline"
require 'pry'
require "json-socket"

load 'random_port.rb'
load 'puppeteer.rb'

# port = RandomPort.acquire
# node_pid = spawn("node puppeteer_server.js #{port}")
# client = JSONSocket::Client.new(host: "localhost", port: port)
binding.pry

# 10.times do |i|
#   result = client.send({ "a" => i, "b" => i + 10 })
#   p result
#   sleep 2
# end

# Process.detach(Puppeteer::PID)
# Process.kill("HUP", Puppeteer::PID)

# // var message = client.send({store: 'browser', method:'puppeteer.launch', args: [{headless: false}]});
# // var message = {store: 'page', eval:'(await v.browser.pages())[0]'};
# /var message = {method:'page.goto', args: ['https://news.ycombinator.com']};
# await page.content()

# {return: true, method:'page.content'};