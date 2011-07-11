require 'spec_helper'

describe Element do
  context "objects" do
    let(:element) { Factory(:element) }
    
    it "updates the versions table when updated" do
      element.versions.count.should == 0
      element.update_attributes(:content => "Hello everyone!")
      element.versions.count.should == 1

      element.current_version.should == 2
      version = element.versions.first
      version.content.should == "Hello world!"
    end
  end
end
