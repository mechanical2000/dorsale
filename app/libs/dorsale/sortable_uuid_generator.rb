# Microtime based uuids to be sortable
class Dorsale::SortableUUIDGenerator
  REGEX_WITH_DASH    = /^([0-9a-f]{8})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{4})-([0-9a-f]{12})$/
  REGEX_WITHOUT_DASH = /^([0-9a-f]{8})([0-9a-f]{4})([0-9a-f]{4})([0-9a-f]{4})([0-9a-f]{12})$/

  def self.generate
    prefix = Time.zone.now.to_f.to_s.gsub(".", "").ljust(20, "0").to_i.to_s(16)
    suffix = SecureRandom.hex(16).slice(0, 32-prefix.length)
    (prefix + suffix).gsub(REGEX_WITHOUT_DASH, '\1-\2-\3-\4-\5')
  end
end
