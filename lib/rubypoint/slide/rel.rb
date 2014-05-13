class RubyPoint::Slide::Rel < RubyPoint::File
  
  def initialize(slide, file=nil)
    @slide = slide
    file ? init_from_file(file) : init_from_new
    @rel_id = 1
  end

  def next_rel_id
    @rel_id += 1
  end

  def add_image_relationship_for(object)
    slide_rel = RubyPoint::Slide::Rel::Image.new(self, object)
    self.objects << slide_rel
    slide_rel
  end
  
  def raw_xml
    raw = <<EOF 
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout2.xml"/></Relationships>
EOF
  end

  private
  
  def init_from_file(file)
    @parent = @slide
    @presentation = @slide.presentation
    @file_path = file
    @doc = Hpricot::XML(File.open(@file_path).read)
  end

  def init_from_new
    @parent = @slide
    @presentation = @slide.presentation
    @file_path = @presentation.slide_directory + "/_rels/slide#{@parent.slide_id}.xml.rels"
    @doc = Hpricot::XML(self.raw_xml)    
  end

end


class RubyPoint::Slide::Rel::SlideLayout < RubyPoint::Relationship
  target "printerSettings/printerSettings1.bin"
  type   "http://schemas.openxmlformats.org/officeDocument/2006/relationships/printerSettings"
end

class RubyPoint::Slide::Rel::Image < RubyPoint::Relationship
  target do |t| 
    t.object.target_dir  # TODO DOES NOT WORK BUT LEFT OFF HERE 
  end
  type   "http://schemas.openxmlformats.org/officeDocument/2006/relationships/image"
end
