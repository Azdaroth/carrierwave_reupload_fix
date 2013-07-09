module CarrierwaveReuploadFix
  class ReuploadFixer
    
    attr_reader :model_instance, :versions_recreator, :extension_assigner
    def initialize(model_instance, versions_recreator, extension_assigner)
      @model_instance = model_instance
      @versions_recreator = versions_recreator
      @extension_assigner = extension_assigner
    end

    def fix
      fix_carrierwave_processing(model_instance)
      handle_associations
    end

    def handle_associations
      model_instance.associations_marked_for_fix_in_nested_attributes.each do |assoc|
        Array(model_instance.send(assoc)).each do |record|
          fix_carrierwave_processing(record) if record.carrierwave_fields_marked_for_fix_on_reupload.present?
        end
      end
    end

    def fix_carrierwave_processing(obj)
      fix_carrierwave(obj)
      assign_extensions(obj)
    end

    private

      def fix_carrierwave(obj)
        obj.carrierwave_fields_marked_for_fix_on_reupload.each do |field|
          versions_recreator.recreate!(obj, field) if extension_changed?(obj, field)
        end
      end

      def assign_extensions(obj)
        obj.carrierwave_fields_marked_for_fix_on_reupload.each do |field|
          current_extension = get_current_extension(obj, field)
          extension_assigner.assign(obj, field, current_extension) unless current_extension.nil?
        end
      end

      def extension_changed?(obj, field)
        previous_extension = obj.send("#{field}_extension".to_sym)
        current_extension = get_current_extension(obj, field)
        current_extension.present? and current_extension != previous_extension
      end

      def get_current_extension(obj, field)
        obj.send(field).to_s.split('.').last
      end

  end
end