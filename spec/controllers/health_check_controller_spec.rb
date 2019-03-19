require "rails_helper"

describe HealthCheckController do
  describe "#show" do
    context "database is up" do
      it "returns 200" do
        get :show

        expect(response.status).to eq 200
      end
    end

    context "database is down" do
      before do
        allow_any_instance_of(described_class).
          to receive(:database_connection_active?).
          and_return(false)
      end

      it "returns 503" do
        get :show

        expect(response.status).to eq 503
      end
    end
  end
end
