module Statsby
  # A set of tags is really just some key value pairs,
  # so we can leverage Ruby's built-in Hash class, simply
  # overriding `#to_s` to get the format that we need.
  # Maybe we can add some validation in the future.
  class TagSet < Hash
    def self.from_hash(hash)
      TagSet.new.merge(hash)
    end

    def to_s
      map { |key, value| "#{key}=#{value}" }.join(',')
    end
  end
end
