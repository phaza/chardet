require 'UniversalDetector'

describe UniversalDetector, '#contains_high_bit?' do

  it 'returns true if data contains one byte with its high bit set' do
    u = UniversalDetector::Detector.instance
    u.contains_high_bit?([ 0x00, 0x80, 0x00 ]).should eq(true)
  end

  it 'returns true if data contains more than one byte with its high bit set' do
    u = UniversalDetector::Detector.instance
    u.contains_high_bit?([ 0x00, 0xDE, 0xAD, 0xBE, 0xEF, 0x00 ]).should eq(true)
  end

  it 'returns false if data contains only bytes with their high bits cleared' do
    u = UniversalDetector::Detector.instance
    u.contains_high_bit?([ 0x00, 0x7F ]).should eq(false)
  end

end

describe UniversalDetector, '#contains_escape?' do

  it 'returns true if data contains an escape character' do
    u = UniversalDetector::Detector.instance
    u.contains_escape?([ 0x77, 0x30, 0x30, 0x1B, 0x74 ]).should eq(true)
  end

  it 'returns true if data contains an escape sequence' do
    u = UniversalDetector::Detector.instance
    u.contains_escape?([ 0x77, 0x30, 0x30, 0x7E, 0x7B, 0x74 ]).should eq(true)
  end

  it 'returns true if data contains more than one escape character' do
    u = UniversalDetector::Detector.instance
    u.contains_escape?([ 0x77, 0x1B, 0x30, 0x30, 0x1B, 0x74 ]).should eq(true)
  end

  it 'returns true is data contains more than one escape sequence' do
    u = UniversalDetector::Detector.instance
    u.contains_escape?([ 0x77, 0x7E, 0x7B, 0x30, 0x30, 0x7E, 0x7B, 0x74 ]).should eq(true)
  end

  it 'returns false if data does not contain any escape characters or sequences' do
    u = UniversalDetector::Detector.instance
    u.contains_escape?([ 0x77, 0x30, 0x30, 0x74 ]).should eq(false)
  end

end