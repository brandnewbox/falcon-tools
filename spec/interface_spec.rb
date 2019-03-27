require "spec_helper"
require "falcon-tools"

RSpec.describe "Interface" do
  it "is true" do
    expect(true).to eq true
  end

  it "fails silently if no username/password is provided" do
    expect{FalconTools::Interface.new}.not_to raise_error
  end

  describe "#find" do
    it "fails silently if no username/password is provided" do
      fti = FalconTools::Interface.new
      expect{fti.find(:projects)}.not_to raise_error
    end

    it "returns an empty hash if the token is nil" do
      fti = FalconTools::Interface.new
      expect(fti.find(:projects)).to eq({})
    end

  end

  describe "#find_project_by_name" do
    it "fails silently if no username/password is provided" do
      fti = FalconTools::Interface.new
      expect{fti.find_project_by_name("name")}.not_to raise_error
    end

    it "returns nil if the token is nil" do
      fti = FalconTools::Interface.new
      expect(fti.find_project_by_name("name")).to eq(nil)
    end

  end

  describe "with bad username/password" do
    it "fails silently if @token is nil" do
      ENV['FALCON_TOOLS_USERNAME'] = "username"
      ENV['FALCON_TOOLS_PASSWORD'] = "password"
      expect{FalconTools::Interface.new}.not_to raise_error
    end
  end

  describe "#token_expired?" do
    it "is false if the @token_expiration is nil" do
      fti = FalconTools::Interface.new
      fti.instance_variable_set(:@token_expiration, nil)
      expect(fti.send(:token_expired?)).to be true
    end

    it "is true if the @token_expiration is < DateTime.now" do
      fti = FalconTools::Interface.new
      fti.instance_variable_set(:@token_expiration, DateTime.now - 1.day)
      expect(fti.send(:token_expired?)).to be true
    end
  end
end
