require 'socket'

module Statsby
  # Most StatsD endpoints will be UDP.
  # This is a super simple wrapper around UPDSocket
  class UDPMetricsWriter
    DEFAULT_HOST = 'localhost'.freeze
    DEFAULT_PORT = 8125

    attr_reader :socket, :host, :port

    def initialize(host = DEFAULT_HOST, port = DEFAULT_PORT)
      self.socket = ::UDPSocket.new
      self.host = host
      self.port = port
    end

    def write(message)
      socket.send(message, 0, host, port)
    end

    private

    attr_writer :socket, :host, :port
  end
end
