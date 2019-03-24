require "rails_helper"

describe HostnameController do
  describe "#show" do
    it "returns 200" do
      get :show

      expect(response.status).to eq 200
    end
  end
end
