require 'statsby/udp_metrics_writer'

module Statsby
  # Use a Statsby::Client to send metrics to a StatsD server
  class Client
    attr_reader :metrics_writer, :tags, :tags_enabled

    def initialize(
      metrics_writer: UDPMetricsWriter.new,
      tags: {},
      tags_enabled: true
    )
      self.metrics_writer = metrics_writer
      self.tags = Statsby::TagSet.from_hash(tags)
      self.tags_enabled = tags_enabled
    end

    def send_message(message)
      metrics_writer.write(message)
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

    def subcontext(tags = {})
      Statsby::Context.new(self, tags)
    end

    private

    attr_writer :metrics_writer, :tags, :tags_enabled
  end
end
