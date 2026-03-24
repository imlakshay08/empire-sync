require 'typhoeus'

Typhoeus::Config.verbose = false

Typhoeus.before do |request|
  request.options[:ssl_verifypeer] = false
  request.options[:ssl_verifyhost] = 0
end