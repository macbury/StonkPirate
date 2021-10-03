ActiveRecord::Encryption.configure(
  primary_key: ENV.fetch('ENCRYPTION_PRIMARY_KEY'),
  deterministic_key: ENV.fetch('ENCRYPTION_DETERMINISTIC_KEY'),
  key_derivation_salt: ENV.fetch('ENCRYPTION_KEY_DERIVATION_SALT'),
)