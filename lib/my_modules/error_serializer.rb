module MyModules  
  module ErrorSerializer

    def ErrorSerializer.serialize(errors)
      return if errors.nil?

      json = {}
      new_hash = errors.messages.map do |k, v|
        v.map do |msg|
          { status: 422,
            source: {"pointer": "data/attributes/#{k}"},
            detail: msg
          }
        end
      end.flatten
      json[:errors] = new_hash
      json
    end

  end
end