# Enhance Hash
# Imported from rails/active_support
class Hash
  def symbolize_keys
    each_with_object({}) do |(key, value), options|
      options[(begin
                 key.to_sym
               rescue StandardError
                 key
               end) || key] = value
    end
  end

  def except(*keys)
    dup.except!(*keys)
  end

  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end
end
