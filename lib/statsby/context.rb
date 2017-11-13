require 'statsby/tag_set'
module Statsby
  # This is meant to be used as a thin layer over a
  # client or another context as a way to organize tags.
  class Context
    attr_reader :super_context, :tags

    def initialize(super_context, tags = {})
      @super_context = super_context
      @tags = Statsby::TagSet.from_hash(tags)
    end

    def counter(metric_name, value, local_tags = {})
      combined_tags = tags.merge(local_tags)
      super_context.counter(metric_name, value, combined_tags)
    end

    def gauge(metric_name, value, local_tags = {})
      combined_tags = tags.merge(local_tags)
      super_context.counter(metric_name, value, combined_tags)
    end

    def timing(metric_name, value, local_tags = {})
      combined_tags = tags.merge(local_tags)
      super_context.counter(metric_name, value, combined_tags)
    end

    def set(metric_name, value, local_tags = {})
      combined_tags = tags.merge(local_tags)
      super_context.counter(metric_name, value, combined_tags)
    end

    def format_tags(message_tags = {})
      super_context.format_tags(tags.merge(message_tags))
    end

    def format_message(metric_name, value, type, message_tags = {})
      combined_tags = tags.merge(message_tags)
      super_context.format_message(metric_name, value, type, combined_tags)
    end

    def subcontext(tags = {})
      Statsby::Context.new(self, tags)
    end
  end
end
