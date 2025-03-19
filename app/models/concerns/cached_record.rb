require 'active_support/concern'
module CachedRecord
  extend ActiveSupport::Concern
  included do
    after_commit :clear_cached_records
  end

  class_methods do
    def cacheable_records
      all
    end

    def cached_records
      Rails.cache.fetch("cached_records_#{model_name.collection}") { cacheable_records.load }
    end

    def [](*ids, **options)
      return ids.map { |i| self[i, **options] } if ids.length > 1

      options.reverse_merge!({
        case_sensitive: false,
        collection: cached_records
      })

      id = ids.first
      return nil if id.blank?
      return id if id.is_a?(self)

      id = id.to_s if id.is_a?(Symbol)
      if id.is_a?(String)
        regexp = Regexp.new("\\A#{Regexp.escape(id).gsub(/(\\?\s|_)/, '(\s|_)')}\\z", options[:case_sensitive] ? nil : Regexp::IGNORECASE)
        options[:collection].detect { |s| s.cache_key =~ regexp }
      else
        options[:collection].detect { |s| s.id == id }
      end
    end

    def clear_cached_records
      Rails.cache.delete("cached_records_#{model_name.collection}")
    end

    def method_missing(name)
      self[name].presence || super
    end
  end

  def clear_cached_records
    self.class.clear_cached_records
  end

  def cache_key
    respond_to?(:name) ? self.name : nil
  end
end
