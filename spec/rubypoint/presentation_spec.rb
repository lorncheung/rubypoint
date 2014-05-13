require File.dirname(__FILE__) + '/../spec_helper'

describe RubyPoint::Presentation do
  it "should not raise an error when initializing a new presentation" do
    lambda {
      RubyPoint::Presentation.new('base.pptx')
    }.should_not raise_error
  end
  
  describe 'with a base file' do

    before(:each) do
      @rp = RubyPoint::Presentation.new('base.pptx')
    end
    
    it "should load the slides in the file" do
      @rp.slides.size.should == 1
      @rp.slides.all? { |s| s.is_a?(RubyPoint::Slide) }.should be_true
    end

    describe "#new_slide" do
      let(:temp1) { "spec/assets/tempimage.jpeg"}
      let(:temp2) { "spec/assets/sample_image.png"}

      it "should add a new slide to the presentation" do
        @rp.new_slide
        @rp.slides[0] << RubyPoint::ImageField.new(temp1,203600,203600,8754800,6515200)
        @rp.slides[1] << RubyPoint::ImageField.new(temp2,203600,203600,8754800,6515200)
        @rp.save("foobar2.pptx")
      end
    end
  end
  
end
