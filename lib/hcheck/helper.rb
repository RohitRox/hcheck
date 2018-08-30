# Enhance Hash
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
end
