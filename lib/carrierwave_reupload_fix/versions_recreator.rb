module CarrierwaveReuploadFix
  class VersionsRecreator
   
    def recreate!(model_instance, field)
      model_instance.send(field).recreate_versions!
    end

  end
end