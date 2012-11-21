require "spec_helper"

describe "XmlConvert" do

  describe ".encode_name" do
    it "returns nil when argument is nil" do
      XmlConvert.encode_name(nil).should eq nil
    end

    it "returns the empty string when argument is an empty string" do
      XmlConvert.encode_name("").should eq ""
    end

    it "does not escape underscores when no escaping is required" do
      XmlConvert.encode_name("Order_Details").should eq "Order_Details"
    end

    it "escapes spaces" do
      XmlConvert.encode_name("Order Details").should eq "Order_x0020_Details"
    end

    it "escapes characters that could be an escape sequence" do
      XmlConvert.encode_name("Order_x0020_").should eq "Order_x005f_x0020_"
    end

    it "escapes periods as first letter" do
      XmlConvert.encode_name(".Order").should eq "_x002e_Order"
    end

    it "does not escape colons" do
      XmlConvert.encode_name("a:b").should eq "a:b"
    end
  end

  describe ".encode_local_name" do
    it "escapes colons" do
      XmlConvert.encode_local_name("a:b").should eq "a_x003a_b"
    end
  end
end