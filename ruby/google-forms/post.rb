#!/usr/bin/env ruby

require "ftw"
require "cgi"
formkey = ARGV.shift

def encode(hash)
  return hash.collect do |key, value|
    CGI.escape(key) + "=" + CGI.escape(value)
  end.join("&")
end # def encode

params = {}
ARGV.each_with_index do |arg, i|
  params["entry.#{i}.single"] = arg
end

# The google form doesn't think it's a valid submission if this isn't set.
params["submit"] = "Submit"

agent = FTW::Agent.new
response = agent.post!("https://docs.google.com/spreadsheet/formResponse?formkey=#{formkey}&ifq",
           :headers => { 
             "Content-Type" => "application/x-www-form-urlencoded",
             "Accept" => "*/*" 
           }, :body => encode(params))
puts response
response.read_body { |chunk| $stdout.write(chunk) }
