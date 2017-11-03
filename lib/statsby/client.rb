require 'socket'

module Statsby
  # Use a Statsby::Client to send metrics over UDP to a StatsD server
  class Client
    attr_reader :socket, :host, :port, :tags_enabled

    def initialize(host: 'localhost', port: 8125, tags_enabled: true)
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

    def send_counter(metric_name, value, tags = {})
      send_message(metric_name, value, 'c', tags)
    end

    def send_gauge(metric_name, value)
      send_message(metric_name, value, 'g')
    end

    def send_timing(metric_name, value)
      send_message(metric_name, value, 'ms')
    end

    def send_set(metric_name, value)
      send_message(metric_name, value, 's')
    end

    def format_tags(tags)
      tags.map { |key, value| "#{key}=#{value}" }.join(',') if tags_enabled
    end
  end
end
