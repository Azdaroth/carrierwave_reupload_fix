require "carrierwave_reupload_fix/version"
require "carrierwave_reupload_fix/reupload_fixer"
require "carrierwave_reupload_fix/versions_recreator"
require "carrierwave_reupload_fix/extensions_assigner"
require 'active_support/concern'
require 'active_support/core_ext/object'

module CarrierwaveReuploadFix
  extend ActiveSupport::Concern

  included do

    def self.carrierwave_fields_marked_for_fix_on_reupload
      @carrierwave_fields_marked_for_fix_on_reupload ||= []
    end

    def self.associations_marked_for_fix_in_nested_attributes
      @associations_marked_for_fix_in_nested_attributes ||= []
    end

    def self.fix_on_reupload(*marked_fields)  
      fields = carrierwave_fields_marked_for_fix_on_reupload
      marked_fields.each { |field| fields << field }
      @carrierwave_fields_marked_for_fix_on_reupload = fields
    end

    def self.nested_fix_on_reupload(*associations)
      assocs = associations_marked_for_fix_in_nested_attributes
      associations.each { |assoc| assocs << assoc }
      @associations_marked_for_fix_in_nested_attributes = assocs
    end

    def carrierwave_fields_marked_for_fix_on_reupload
      self.class.carrierwave_fields_marked_for_fix_on_reupload
    end

    def associations_marked_for_fix_in_nested_attributes
      self.class.associations_marked_for_fix_in_nested_attributes
    end

    alias :original_update :update

    def update(args)
      original_update(args)
      ReuploadFixer.new(self, VersionsRecreator.new, ExtensionsAssigner.new).fix
    end
  end
end