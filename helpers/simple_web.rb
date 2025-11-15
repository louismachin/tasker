# Louis Machin - machin.dev
# Methods to quickly send GET/POST requests to an API
# Use only for bodge scripts - not production!

require 'net/http'
require 'cgi'
require 'uri'
require 'json'
require 'date'

def simple_post_text(url, params = {}, body = nil)
    uri = URI(url)
    uri.query = URI.encode_www_form(params) unless params == {}
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl, http.verify_mode = true, OpenSSL::SSL::VERIFY_NONE
    params['Content-Type'] = 'text/plain'
    req = Net::HTTP::Post.new(uri.request_uri, params)
    req.body = body
    res = http.request(req)
    return res
end

def simple_post_json(url, params = {}, body = nil)
    uri = URI(url)
    uri.query = URI.encode_www_form(params) unless params == {}
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl, http.verify_mode = true, OpenSSL::SSL::VERIFY_NONE
    params['Content-Type'] = 'application/json'
    req = Net::HTTP::Post.new(uri.request_uri, params)
    req.body = body.to_json unless body == nil
    res = http.request(req)
    return res
end

def simple_get(url, params = {}, headers = {})
    uri = URI(url)
    uri.query = URI.encode_www_form(params) unless params == {}
    req = Net::HTTP::Get.new(uri)
    headers.each { |key, value| req[key] = value }
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |r| r.request(req) }
    return res
end

def simple_get_body(url, params = {}, headers = {})
    res = simple_get(url, params, headers)
    return res.code == '200' ? JSON.parse(res.body) : {}
end