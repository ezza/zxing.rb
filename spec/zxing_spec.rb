require 'spec_helper'
require 'zxing'

class Foo
  def path
    File.expand_path("../fixtures/example.png", __FILE__)
  end
end

describe ZXing do
  describe ".decode" do
    subject { ZXing.decode(file) }

    context "with a string path to image" do
      let(:file) { fixture_image("example") }
      it { should == "example" }
    end

    context "with a uri" do
      let(:file) { "http://2d-code.co.uk/images/bbc-logo-in-qr-code.gif" }
      it { should == "http://bbc.co.uk/programmes" }
    end

    context "with an instance of File" do
      let(:file) { File.new(fixture_image("example")) }
      it { should == "example" }
    end

    context "with an object that responds to #path" do
      let(:file) { Foo.new }
      it { should == "example" }
    end

    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it { should be_nil }
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "File nonexistentfile.png could not be found")
      end
    end

  end

  describe ".decode!" do
    subject { ZXing.decode!(file) }

    context "with a qrcode file" do
      let(:file) { fixture_image("example") }
      it { should == "example" }
    end

    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it "raises an error" do
        expect { subject }.to raise_error(ZXing::UndecodableError, "Image not decodable")
      end
    end

    context "when the image cannot be decoded from a URL" do
      let(:file) { "http://www.google.com/logos/grandparentsday10.gif" }
      it "raises an error" do
        expect { subject }.to raise_error(ZXing::UndecodableError, "Image not decodable")
      end
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "File nonexistentfile.png could not be found")
      end
    end
  end

  describe ".decode_all" do
    subject { ZXing.decode_all(file) }

    context "with a single barcoded image" do
      let(:file) { fixture_image("example") }
      it { should == ["example"] }
    end

    context "with a multiple barcoded image" do
      let(:file) {fixture_image("multi_barcode_example") }
      it { should == ['test456','test123']}
    end

    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it { should == [] }
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "File nonexistentfile.png could not be found")
      end
    end

  end

  describe ".decode_all!" do
    subject { ZXing.decode_all!(file) }

    context "with a single barcoded image" do
      let(:file) { fixture_image("example") }
      it { should == ["example"] }
    end

    context "with a multiple barcoded image" do
      let(:file) {fixture_image("multi_barcode_example") }
      it { should == ['test456','test123']}
    end

    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it "raises an error" do
        expect { subject }.to raise_error(ZXing::UndecodableError, "Image not decodable")
      end
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "File nonexistentfile.png could not be found")
      end
    end
  end

  describe ".decode_objects!" do
    subject { ZXing.decode_objects!(file) }

    context "with a single barcoded image" do
      let(:file) { fixture_image("example") }
      its(:size) { should eq(1) }

      its("first.text") { should eq('example' )}
      its("first.to_s") { should eq('example' )}
      its("first.result_metadata") { should be_nil}
    end

    context "with a multiple barcoded image" do
      let(:file) {fixture_image("multi_barcode_example") }
      its(:size) { should eq(2) }

      its("first.to_s") { should eq('test456' )}
      its("first.result_metadata") { should be_nil}
      its("first.point_coordinates") { should eq([[15.0, 735.0], [15.0, 707.0], [43.0, 707.0]])}

      its("last.to_s") { should eq('test123' )}
      its("last.result_metadata") { should be_nil}
      its("last.point_coordinates") { should eq([[569.0, 43.0], [569.0, 15.0], [597.0, 15.0]])}
    end
    
    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it "raises an error" do
        expect { subject }.to raise_error(ZXing::UndecodableError, "Image not decodable")
      end
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "File nonexistentfile.png could not be found")
      end
    end
  end

  describe ".decode_objects" do
    subject { ZXing.decode_objects(file) }

    context "with a single barcoded image" do
      let(:file) { fixture_image("example") }
      its(:size) { should eq(1) }

      its("first.text") { should eq('example' )}
      its("first.to_s") { should eq('example' )}
      its("first.result_metadata") { should be_nil}
    end

    context "with a multiple barcoded image" do
      let(:file) {fixture_image("multi_barcode_example") }
      its(:size) { should eq(2) }

      its("first.to_s") { should eq('test456' )}
      its("first.result_metadata") { should be_nil}
      its("first.point_coordinates") { should eq([[15.0, 735.0], [15.0, 707.0], [43.0, 707.0]])}

      its("last.to_s") { should eq('test123' )}
      its("last.result_metadata") { should be_nil}
      its("last.point_coordinates") { should eq([[569.0, 43.0], [569.0, 15.0], [597.0, 15.0]])}
    end

    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it { should == [] }
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "File nonexistentfile.png could not be found")
      end
    end
  end

end
