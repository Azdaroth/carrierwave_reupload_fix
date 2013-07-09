$: << File.join(File.dirname(__FILE__), "/../lib")
require 'spec_helper'
require_relative '../lib/carrierwave_reupload_fix' 


class DummyMainModel
  def update(args) ; end

  include CarrierwaveReuploadFix

  def offers
    [DummyAssociatedModel.new, DummyAssociatedModel.new]
  end

  def logo; end

  def image; end

  fix_on_reupload :logo, :image
  nested_fix_on_reupload :offers

end

class DummyAssociatedModel

  def update(args) ; end

  include CarrierwaveReuploadFix

  def photo; end

  fix_on_reupload :photo
end


describe CarrierwaveReuploadFix do

  it "adds fields to be fixed to class instance variables" do
    expect(DummyMainModel.carrierwave_fields_marked_for_fix_on_reupload).to eq [:logo, :image]
  end

  it "adds associations to be fixed" do
    expect(DummyMainModel.associations_marked_for_fix_in_nested_attributes).to eq [:offers]
  end

  specify "instances of models know about fields to be fixed" do
    expect(DummyMainModel.new.carrierwave_fields_marked_for_fix_on_reupload).to eq [:logo, :image]
  end

  specify "instances of models know about associations to be fixed" do
    expect(DummyMainModel.new.associations_marked_for_fix_in_nested_attributes).to eq [:offers]
  end

  it "aliases update to original_update" do
    expect(DummyMainModel.new).to respond_to :original_update
    expect(DummyMainModel.new).to respond_to :update
  end

  it "calls fixer on update" do
    model_instance = DummyMainModel.new
    fixer = double(:fixer)
    recreator = double(:recreator)
    assigner = double(:assigner)
    CarrierwaveReuploadFix::VersionsRecreator.stub(:new) { recreator }
    CarrierwaveReuploadFix::ExtensionsAssigner.stub(:new) { assigner }
    CarrierwaveReuploadFix::ReuploadFixer.should_receive(:new).with(model_instance,
        recreator, assigner) { fixer }
    fixer.should_receive(:fix)
    model_instance.update({})
  end

end

