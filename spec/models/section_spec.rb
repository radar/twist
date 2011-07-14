require 'spec_helper'

describe Section do
  it "can retreive ancestors" do
    section_1 = Section.create!(:title => "Parent")
    section_2 = section_1.sections.create!(:title => "Child")
    section_3 = section_2.sections.create!(:title => "Grandchild")
    
    section_3.ancestors.should == [section_2, section_1]
  end
end
