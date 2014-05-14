require File.dirname(__FILE__) + '/../../spec_helper'
# @rp = RubyPoint::Presentation.new('base.pptx’)
# textfield = RubyPoint::TextField.new("Hello WOrld part deux”)
# slide = @rp.slides[0]
# slide << textfield
#  @rp.save("pptwithtext2.pptx")


describe RubyPoint::Slide do

  let(:rp)        { RubyPoint::Presentation.new('base.pptx') }
  let(:slide)     { rp.slides.first }
  let(:doc)       { doc_from(slide) }
  let(:tempimage) { "spec/assets/tempimage.jpeg"}


  context "inserting a textfield" do
    before(:each) do
      slide << RubyPoint::TextField.new("Obligatory hello world!",1,2,5000,9000)
      slide.write
    end

    it "should insert the correct xml block" do
      doc.search("//p:sp").html.should match(/Obligatory hello world!/)
    end

    it "should set the correct textfield positions" do
      element = doc.search("//p:spPr//a:xfrm//a:off")
      element.should_not be_nil
      element.attr('x').should == "1"
      element.attr('y').should == "2"      
    end
  end

  context "inserting an imagefield" do

    # EMU units of measurment (1inch = 814400emu)
    before(:each) do
      slide << RubyPoint::ImageField.new(tempimage,1,2,8551200,6515200)
      slide.write
    end

    it "should create a media directory" do
      Dir.exists?(rp.file_directory + "/ppt/media").should be_true
    end

    it "should insert file into media directory" do
      File.exists?(rp.file_directory + "/ppt/media/tempimage.jpeg").should be_true
    end

    it "should add a slide relationship xml block" do
      elements = slide.slide_rel.doc.search("//Relationship")
      elements.inject(false){|x,y| x || !!y['Target'].match("tempimage")} 
    end
  end

  context "macro tests" do
    context "saving a presentation file" do
      it "should have the extension value in content type" do
        # .25 inch border on each side, centered based on 8.5"x11" 
        rp.slides.first << RubyPoint::ImageField.new(tempimage,203600,203600,8754800,6515200)
        rp.save("foobar.pptx")
        pending
      end
    end
  end
end



