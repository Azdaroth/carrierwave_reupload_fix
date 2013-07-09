require 'spec_helper'


describe CarrierwaveReuploadFix::VersionsRecreator do 

  it "calls recreate_version! on specified file" do
    recreator = CarrierwaveReuploadFix::VersionsRecreator.new
    obj = double(:obj, image: double)
    obj.image.should_receive(:recreate_versions!)
    recreator.recreate!(obj, :image)
  end

end