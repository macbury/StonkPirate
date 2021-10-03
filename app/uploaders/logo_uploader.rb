class LogoUploader < Shrine
  plugin :determine_mime_type, analyzer: :marcel
  plugin :validation_helpers
  plugin :remote_url, max_size: 15.megabytes
 
  Attacher.validate do
    validate_extension %w[jpg jpeg png webp]
    validate_mime_type %w[image/jpeg image/png image/webp]
  end
end