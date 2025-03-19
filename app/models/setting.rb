class Setting < ApplicationRecord
  DEFAULT_SETTINGS = {
    'mail_address' => ENV['MAIL_ADDRESS'],
    'mail_port' => ENV['MAIL_PORT'],
    'mail_domain' => ENV['MAIL_DOMAIN'],
    'mail_username' => ENV['MAIL_USERNAME'],
    'mail_password' => ENV['MAIL_PASSWORD'],
    'mail_authentication' => ENV['MAIL_AUTHENTICATION'],
    'mail_signature' => '',
  }.freeze

  include CachedRecord

  encrypts :value

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true

  def self.[](*ids, **options)
    ids.length > 1 ? super : super&.value
  end

  def self.create_default_settings!
    transaction do
      DEFAULT_SETTINGS.each do |name, value|
        create!(name: name, value: value)
      end
    end
  end
end
