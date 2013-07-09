module CarrierwaveReuploadFix
  class ExtensionsAssigner
    
    def assign(model_instance, field, extension)
      model_instance.send("#{field}_extension=", extension)
      model_instance.save
    end

  end
end