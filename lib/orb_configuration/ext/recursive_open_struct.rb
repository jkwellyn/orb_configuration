class RecursiveOpenStruct < OpenStruct
  def keys
    to_h.keys
  end
end
