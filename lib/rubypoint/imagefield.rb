class RubyPoint::ImageField < RubyPoint::Element
  attr_accessor :filepath, :text, :x, :y, :width, :height, :rel_id, :slide, :target_dir
  
  def initialize(filepath,x=3200400, y=4572000, w=3200400, h=572000, text="")
    @dirty    = true
    @filepath = filepath
    @text     = text
    @x, @y, @width, @height = x, y, w, h
    @slide    = @parent
  end

  def write
    if !Dir.exists? media_directory
      Dir.mkdir(media_directory) 
    end   
    if (system("cp #{filepath} #{media_directory}")) 
      @target_dir = "../media/#{filename}"
    end
    @parent.add_to_relationships(self)
    @parent.doc.search('//p:spTree').append(self.raw)

    #@parent.objects << RubyPoint::Slide::Rel::Image.new(@parent)
  end

  def raw
    raw = <<EOF 
<p:pic>
  <p:nvPicPr>
    <p:cNvPr id="#{self.xml_id}" name="Picture #{self.xml_id}" descr="#{self.filename}" />
    <p:cNvPicPr>
      <a:picLocks noChangeAspect="1"/>
    </p:cNvPicPr>
    <p:nvPr/>
  </p:nvPicPr>
  <p:blipFill>
    <a:blip r:embed="rId2">
      <a:extLst>
        <a:ext uri="{28A0092B-C50C-407E-A947-70E740481C1C}">
          <a14:useLocalDpi xmlns:a14="http://schemas.microsoft.com/office/drawing/2010/main" val="0"/>
        </a:ext>
      </a:extLst>
    </a:blip>
    <a:stretch>
      <a:fillRect/>
    </a:stretch>
  </p:blipFill>
  <p:spPr>
    <a:xfrm>
      <a:off x="#{self.x}" y="#{self.y}"/>
      <a:ext cx="#{self.width}" cy="#{self.height}"/>
    </a:xfrm>
    <a:prstGeom prst="rect">
      <a:avLst/>
    </a:prstGeom>
  </p:spPr>
</p:pic>
EOF
  end

  def filename
    filepath.split('/').last
  end  

  private 

  def media_directory
    return presentation.media_directory unless presentation.nil?
    return parent.presentation.media_directory unless parent.nil?
    return nil
  end
end
