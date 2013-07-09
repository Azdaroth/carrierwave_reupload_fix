require 'spec_helper'

describe CarrierwaveReuploadFix::ExtensionsAssigner do 

  it "assigns extenions and saves record" do
    obj = double(:obj)
    assigner = CarrierwaveReuploadFix::ExtensionsAssigner.new
    obj.should_receive("image_extension=").with("jpg") { obj }
    obj.should_receive(:save)
    assigner.assign(obj, :image, "jpg")
  end

end