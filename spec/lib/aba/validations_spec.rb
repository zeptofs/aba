# encoding: UTF-8

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

      subject.attr1 = "hello!"
      expect(subject.valid?).to eq true
    end

    it "should validate bsb format" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_bsb :attr1
      end

      subject.attr1 = "234456"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 format is incorrect"]

      subject.attr1 = "234-456"
      expect(subject.valid?).to eq true
    end

    it "should validate max length" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_max_length :attr1, 5
      end

      subject.attr1 = "234456642"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 length must not exceed 5 characters"]

      subject.attr1 = "23445"
      expect(subject.valid?).to eq true

      subject.attr1 = "2344"
      expect(subject.valid?).to eq true
    end

    it "should validate length" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_length :attr1, 5
      end

      subject.attr1 = "234456642"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 length must be exactly 5 characters"]

      subject.attr1 = "23445"
      expect(subject.valid?).to eq true

      subject.attr1 = "2344"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 length must be exactly 5 characters"]
    end

    it "should validate signed integer" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_integer :attr1
      end

      subject.attr1 = "+1234A"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 must be a number"]

      subject.attr1 = "+1234"
      expect(subject.valid?).to eq true

      subject.attr1 = "-1234"
      expect(subject.valid?).to eq true

      subject.attr1 = "1234"
      expect(subject.valid?).to eq true
    end

    it "should validate unsigned integer" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_integer :attr1, false
      end

      subject.attr1 = "1234A"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 must be an unsigned number"]

      subject.attr1 = "+1234"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 must be an unsigned number"]

      subject.attr1 = "-1234"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 must be an unsigned number"]

      subject.attr1 = "1234"
      expect(subject.valid?).to eq true

      subject.attr1 = 1234
      expect(subject.valid?).to eq true
    end

    it "should validate account number" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_account_number :attr1
      end

      subject.attr1 = "      "
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 must be a valid account number"]

      subject.attr1 = "000000"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 must be a valid account number"]

      subject.attr1 = "00 0 0"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 must be a valid account number"]

      subject.attr1 = "00 0A0"
      expect(subject.valid?).to eq true

      subject.attr1 = "00 111"
      expect(subject.valid?).to eq true

      subject.attr1 = "0a 111"
      expect(subject.valid?).to eq true

      subject.attr1 = "aaaaaa"
      expect(subject.valid?).to eq true

      subject.attr1 = "aa aaa"
      expect(subject.valid?).to eq true

      subject.attr1 = "1A2B3C"
      expect(subject.valid?).to eq true
    end

    it "should validate becs" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_becs :attr1
      end

      subject.attr1 = "abc123 é"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 must not contain invalid characters"]

      subject.attr1 = "abc123 ~"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["attr1 must not contain invalid characters"]

      subject.attr1 = "abc123"
      expect(subject.valid?).to eq true
    end

    it "should validate indicator" do
      clean_room.instance_eval do
        attr_accessor :attr1
        validates_indicator :attr1
      end

      subject.attr1 = "$"
      expect(subject.valid?).to eq false
      list = described_class::INDICATORS.join('\', \'')
      expect(subject.errors).to eq ["attr1 must be a one of '#{list}'"]

      subject.attr1 = described_class::INDICATORS.sample
      expect(subject.valid?).to eq true
    end

    it "should validate transaction code" do
      clean_room.instance_eval do
        attr_accessor :transaction_code
        validates_transaction_code :transaction_code
      end

      subject.transaction_code = "AA"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["transaction_code must be one of #{described_class::transaction_codes.join(', ')}"]

      subject.transaction_code = "1"
      expect(subject.valid?).to eq false
      expect(subject.errors).to eq ["transaction_code must be one of #{described_class::transaction_codes.join(', ')}"]

      subject.transaction_code = "13"
      expect(subject.valid?).to eq true

      subject.transaction_code = 50
      expect(subject.valid?).to eq true
    end
  end
end
