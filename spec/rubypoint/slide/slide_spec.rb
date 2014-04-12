require File.dirname(__FILE__) + '/../../spec_helper'
# @rp = RubyPoint::Presentation.new('base.pptx’)
# textfield = RubyPoint::TextField.new("Hello WOrld part deux”)
# slide = @rp.slides[0]
# slide << textfield
#  @rp.save("pptwithtext2.pptx")


describe RubyPoint::Slide do

  let(:rp)    { RubyPoint::Presentation.new('base.pptx') }
  let(:slide) { rp.slides.first }
  let(:doc)   { doc_from(slide) }


  context "inserting a textfield" do
    before(:each) do
      slide << RubyPoint::TextField.new("Obligatory hello world!",1,2,5000,9000)
      slide.write
    end

    it "should insert the correct string" do
      doc.search("//p:sp").html.should match(/Obligatory hello world!/)
    end

    it "should set the correct textfield positions" do
      element = doc.search("//p:spPr//a:xfrm//a:off")
      element.should_not be_nil

      element.attr('x').should == "1"
      element.attr('y').should == "2"      
    end
  end

end



