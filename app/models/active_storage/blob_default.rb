# frozen_string_literal: true

class ActiveStorage::BlobDefault < ApplicationRecord
  self.table_name = 'active_storage_blob_defaults'
  has_one_attached :file

  after_commit :delete_private_cache, :delete_default_cache, on: [:create, :destroy]
  after_update_commit :delete_private_cache, if: -> { saved_change_to_private? }
  after_update_commit :delete_default_cache

  def delete_private_cache
    r = Rails.cache.delete('blob_default/private')
    logger.debug "Cache key blob_default/private delete: #{r}"
  end

  def delete_default_cache
    r = Rails.cache.delete('blob_default/default')
    logger.debug "Cache key blob_default/default delete: #{r}"
  end

  def self.defaults
    Rails.cache.fetch('blob_default/default') do
      ActiveStorage::BlobDefault.includes(:file_attachment).map do |i|
        ["#{i.record_class}_#{i.name}", i.file_attachment.blob_id]
      end.compact.to_h
    end
  end
  
  def self.cache_clear
    Rails.cache.delete('blob_default/private')
    Rails.cache.delete('blob_default/default')
  end

end
