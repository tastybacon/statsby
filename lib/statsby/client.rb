require 'socket'

module Statsby
  # Use a Statsby::Client to send metrics over UDP to a StatsD server
  class Client
    DEFAULT_HOST = 'localhost'.freeze
    DEFAULT_PORT = 8125

    attr_reader :socket, :host, :port, :tags_enabled

    def initialize(host: DEFAULT_HOST, port: DEFAULT_PORT, tags_enabled: true)
      @socket = UDPSocket.new
      @host = host
      @port = port
      @tags_enabled = tags_enabled
    end

    def send_message(metric_name, value, type, tags = {})
      message = "#{metric_name}#{format_tags(tags)}:#{value}|#{type}"
      puts "Sending #{message}"
      socket.send(message, 0, host, port)
    end

    def counter(metric_name, value, tags = {})
      send_message(metric_name, value, 'c', tags)
    end

    def gauge(metric_name, value)
      send_message(metric_name, value, 'g')
    end

    def timing(metric_name, value)
      send_message(metric_name, value, 'ms')
    end

    def set(metric_name, value)
      send_message(metric_name, value, 's')
    end

    def format_tags(tags)
      ",#{Statsby::TagSet.from_hash(tags)}" if tags_enabled
    end
  end
end
