require "spec_helper"

describe Aba::Validations do
  let(:clean_room) do 
    Class.new(Object) do
      include Aba::Validations
    end
  end

  subject(:test_instance) { clean_room.new }

  describe "#valid?" do
    it "should validate presence of attrs" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_presence_of :attr1
      end

      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 is empty"]
    end

    it "should validate bsb format" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_bsb :attr1
      end

      subject.attr1 = "234456"

      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 format is incorrect"]
    end

    it "should validate length" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_max_length :attr1, 5
      end

      subject.attr1 = "234456642"

      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 length must not exceed 5 characters"]
    end
  end
end