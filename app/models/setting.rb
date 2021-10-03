class Setting < ApplicationRecord
  enum key: {
    polish_bonds_login: 'polish_bonds_login',
    polish_bonds_password: 'polish_bonds_password',
  }

  validates :key, :value, presence: true
  encrypts :value

  def self.set(key, value)
    Setting.get(key).update(value: value)
  end

  def self.get(key)
    Setting.find_or_initialize_by(key: key).value
  end

  def self.exists?(key)
    Setting.where(key: key).exists?
  end
end
