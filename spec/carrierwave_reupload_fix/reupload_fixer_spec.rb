require 'spec_helper'

describe CarrierwaveReuploadFix::ReuploadFixer do

  let(:associated_obj) { double(:associated_obj,
    image: "image.jpg",
    image_extension: "pdf",
    carrierwave_fields_marked_for_fix_on_reupload: [:image] ) } 

  let(:associated_records) { [associated_obj] }

  let(:model_instance) { double(:model_instance, 
    logo: "logo.jpg",
    logo_extension: "pdf",
    photos: associated_records,
    carrierwave_fields_marked_for_fix_on_reupload: [:logo],
    associations_marked_for_fix_in_nested_attributes: [] ) }

  let(:versions_recreator) { double(:versions_recreator) }
  let(:extensions_assigner) { double(:extensions_assigner) }

  describe "no associations passed" do

    context "extensions changed" do
      it "recreates versions and assigns new extensions" do
        fixer = CarrierwaveReuploadFix::ReuploadFixer.new(model_instance,
          versions_recreator, extensions_assigner)
        versions_recreator.should_receive(:recreate!).with(model_instance, :logo) { true }
        extensions_assigner.should_receive(:assign).with(model_instance, :logo, "jpg")
        fixer.fix
      end
    end

    context "has not changed" do
      it "does not recreate_versions but assign extensions" do
        fixer = CarrierwaveReuploadFix::ReuploadFixer.new(model_instance,
          versions_recreator, extensions_assigner)
        model_instance.stub(:logo_extension) { "jpg" }
        versions_recreator.should_not_receive(:recreate!).with(model_instance, :logo)
        extensions_assigner.should_receive(:assign).with(model_instance, :logo, "jpg") 
        fixer.fix
      end
    end

  end
    

  context "associations passed" do
    it "recreates versions and assigns extensions on associated objects" do
      fixer = CarrierwaveReuploadFix::ReuploadFixer.new(model_instance,
          versions_recreator, extensions_assigner)
      model_instance.stub(:associations_marked_for_fix_in_nested_attributes) { [:photos] }
      versions_recreator.should_receive(:recreate!).with(associated_obj, :image)
      extensions_assigner.should_receive(:assign).with(associated_obj, :image, "jpg") { true }
      fixer.handle_associations
    end
  end

end