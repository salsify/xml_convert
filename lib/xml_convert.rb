require "xml_convert/version"

module XmlConvert

  # Converts an encoded XML name to its original form.
  #
  # @example XmlConvert.decode_name('Order_x0020_Details') #=> 'Order Details'
  #
  # @param [String] name the name to be decoded.
  # @return [String] the decoded name.
  def self.decode_name(name)
    return name if name.nil? || name.length == 0

    pos = name.index('_')
    return name if pos.nil? || pos + 6 >= name.length

    return name if name[pos+1] != 'x' || name[pos+6] != '_'

    name.slice(0, pos) << try_decoding(name[pos+1..-1])
  end  

  # Converts the name to a valid XML name.
  #
  # @example XmlConvert.encode_name('Order Details') #=> 'Order_x0020_Details'
  #
  # @param [String] name the name to be encoded.
  # @return [String] the encoded name.
  def self.encode_name(name)
    return name if name.nil? || name.length == 0

    name.chars.each_with_index.reduce("") do |memo, (c, i)|
      if is_invalid?(c, memo == "")
        memo << "_x#{'%04x' % c.ord}_"
      elsif c == '_' && i+6 < name.length && name[i+1] == 'x' && name[i+6] == '_'
        memo << '_x005f_'
      else
        memo << c
      end
    end
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

  def self.try_decoding(string)
    return string if string.nil? || string.length < 6

    ord = string[1..4].hex

    if ord == 0
      string[0] << decode_name(string[1..-1])
    elsif string.length == 6
      ord.chr
    else
      ord.chr << decode_name(string[6..-1])
    end
  end

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
    case char.ord
    when     ':'.ord,
             'A'.ord ..     'Z'.ord,
             '_'.ord,
             'a'.ord ..     'z'.ord,
            'C0'.hex ..    'D6'.hex,
            'D8'.hex ..    'F6'.hex,
            'F8'.hex ..   '2FF'.hex,
           '370'.hex ..   '37D'.hex,
           '37F'.hex ..  '1FFF'.hex,
          '200C'.hex ..  '200D'.hex,
          '2070'.hex ..  '218F'.hex,
          '2C00'.hex ..  '2FEF'.hex,
          '3001'.hex ..  'D7FF'.hex,
          'F900'.hex ..  'FDCF'.hex,
          'FDFO'.hex ..  'FFFD'.hex,
         '10000'.hex .. 'EFFFF'.hex
      true
    else
      false
    end
  end

  # NameChar ::= NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] |
  #              [#x203F-#x2040]
  def self.is_name_char?(char)
    return true if is_name_start_char?(char)

    case char.ord
    when    '-'.ord,
            '.'.ord,
            '0'.ord ..    '9'.ord,
           'B7'.hex,
          '300'.hex ..  '36F'.hex,
         '203F'.hex .. '2040'.hex
      true
    else
      false
    end
  end
end
