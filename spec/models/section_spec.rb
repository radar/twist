require 'spec_helper'

describe Section do
  before do
    @chapter = Chapter.create!(:title => "Something Good!")
    @section_1 = @chapter.sections.create!(:title => "Parent")
    @section_2 = @section_1.sections.create!(:title => "Child")
    @section_3 = @section_2.sections.create!(:title => "Grandchild")
  end

  it "can retreive ancestors" do
    @section_3.ancestors.should == [@section_2, @section_1]
  end
end
