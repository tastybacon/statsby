require 'socket'

module Statsby
  # Use a Statsby::Client to send metrics over UDP to a StatsD server
  class Client
    DEFAULT_HOST = 'localhost'.freeze
    DEFAULT_PORT = 8125

    attr_reader :socket, :host, :port, :tags, :tags_enabled

    def initialize(
      host: DEFAULT_HOST,
      port: DEFAULT_PORT,
      tags: {},
      tags_enabled: true
    )
      @socket = UDPSocket.new
      @host = host
      @port = port
      @tags = Statsby::TagSet.from_hash(tags)
      @tags_enabled = tags_enabled
    end

    def send_message(message)
      puts "Sending #{message}"
      socket.send(message, 0, host, port)
    end

    def counter(metric_name, value, local_tags = {})
      send_message(format_message(metric_name, value, 'c', local_tags))
    end

    def gauge(metric_name, value, local_tags = {})
      send_message(format_message(metric_name, value, 'g', local_tags))
    end

    def timing(metric_name, value, local_tags = {})
      send_message(format_message(metric_name, value, 'ms', local_tags))
    end

    def set(metric_name, value, local_tags = {})
      send_message(format_message(metric_name, value, 's', local_tags))
    end

    def format_tags(message_tags = {})
      combined_tags = tags.merge(message_tags)
      ",#{combined_tags}" if tags_enabled && !combined_tags.empty?
    end

    def format_message(metric_name, value, type, message_tags = {})
      "#{metric_name}#{format_tags(message_tags)}:#{value}|#{type}"
    end
  end
end
