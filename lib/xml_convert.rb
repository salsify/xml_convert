require "xml_convert/version"

module XmlConvert
  
  # Converts the name to a valid XML name.
  #
  # @example XmlConvert.encode_name('Order Details') #=> 'Order_x0020_Details'
  #
  # @param [String] name the name to be encoded.
  # @return [String, nil] the encoded name or nil if the name cannot be
  #   converted to a string.
  def self.encode_name(name)
    return name if name.nil? || name.length == 0

    encoded_name = ""
    name.chars.each_with_index do |c, i|
      if is_invalid?(c, encoded_name == "")
        encoded_name << "_x#{'%04x' % c.ord}_"
      elsif c == '_' && i+6 < name.length && name[i+1] == 'x' && name[i+6] == '_'
        encoded_name << '_x005f_'
      else
        encoded_name << c
      end
    end
    encoded_name
  end

  # Converts the name to a valid XML local name.
  #
  # @example (see .encode_name)
  # @example XmlConvert.encode_local_name('a:b') #=> 'a_x003a_b'
  #
  # @param (see .encode_name)
  # @return (see .encode_name)
  def self.encode_local_name(name)
    encode_name(name).gsub(':', '_x003a_')
  end

  private

  def self.is_invalid?(char, is_first_letter)
    !self.is_valid?(char, is_first_letter)
  end

  def self.is_valid?(char, is_first_letter)
    is_first_letter ? is_name_start_char?(char) : is_name_char?(char)
  end

  # NameStartChar ::= ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] |
  #                   [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF] |
  #                   [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] |
  #                   [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] |
  #                   [#x10000-#xEFFFF]
  def self.is_name_start_char?(char)
    ord = char.ord

    (ord == ':'.ord)                          ||
    (ord >= 'A'.ord     && ord <= 'Z'.ord)    ||
    (ord == '_'.ord)                          ||
    (ord >= 'a'.ord     && ord <= 'z'.ord)    ||
    (ord >= 'C0'.hex    && ord <= 'D6'.hex)   ||
    (ord >= 'D8'.hex    && ord <= 'F6'.hex)   ||
    (ord >= 'F8'.hex    && ord <= '2FF'.hex)  ||
    (ord >= '370'.hex   && ord <= '37D'.hex)  ||
    (ord >= '37F'.hex   && ord <= '1FFF'.hex) ||
    (ord >= '200C'.hex  && ord <= '200D'.hex) ||
    (ord >= '2070'.hex  && ord <= '218F'.hex) ||
    (ord >= '2C00'.hex  && ord <= '2FEF'.hex) ||
    (ord >= '3001'.hex  && ord <= 'D7FF'.hex) ||
    (ord >= 'F900'.hex  && ord <= 'FDCF'.hex) ||
    (ord >= 'FDFO'.hex  && ord <= 'FFFD'.hex) ||
    (ord >= '10000'.hex && ord <= 'EFFFF'.hex)
  end

  # NameChar ::= NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] |
  #              [#x203F-#x2040]
  def self.is_name_char?(char)
    ord = char.ord

    is_name_start_char?(char)               ||
    (ord == '-'.ord)   || (ord == '.'.ord)  ||
    (ord >= '0'.ord    && ord <= '9'.ord)   ||
    (ord == 'B7'.hex)                       ||
    (ord >= '300'.hex  && ord <= '36F'.hex) ||
    (ord >= '203F'.hex && ord <= '2040'.hex)
  end
end
