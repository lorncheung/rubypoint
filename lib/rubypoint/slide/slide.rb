class RubyPoint::Slide < RubyPoint::File
  
  attr_accessor :slide_id, :rel_id, :slide_rel
  
  def initialize(presentation, file=nil)
    @presentation = presentation
    file ? init_from_file(file) : init_from_new
  end
  
  def raw_xml
    raw = <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mv="urn:schemas-microsoft-com:mac:vml" mc:Ignorable="mv" mc:PreserveAttributes="mv:*" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id="#{self.slide_id}" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld><p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr></p:sld>
EOF
  end

  def slide_rel 
    @slide_rel ||= RubyPoint::Slide::Rel.new(self)
  end

  def add_to_relationships(object)
    self.slide_rel.add_image_relationship_for(object)
    self.slide_rel.write
  end

  private 
  
  def init_from_file(file)
    @file_path = file
    @slide_id  = presentation.next_slide_id
    @rel_id    = presentation.add_to_relationships(self)
    @slide_rel = RubyPoint::Slide::Rel.new(self, presentation.slide_directory +  "/_rels/slide#{@slide_id}.xml.rels")
    @doc = Hpricot::XML(File.open(@file_path).read)
  end

  def init_from_new
    @slide_id  = presentation.next_slide_id
    @file_path = presentation.slide_directory + "/slide#{@slide_id}.xml"
    @rel_id    = presentation.add_to_relationships(self)
    @slide_rel = RubyPoint::Slide::Rel.new(self)
    self.objects << @slide_rel
    presentation.slides << self
    @doc       = Hpricot::XML(self.raw_xml)
  end
end