require 'rails_helper'

RSpec.describe "Battleship API", type: :request do
  describe "POST /battleship" do
    it "initializes the game" do
      post "/battleship", params: { positions: [[0, 3], [4, 8], [6, 6]] }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("ok")
    end
  end

  describe "PUT /battleship" do
    before do
      post "/battleship", params: { positions: [[0, 3], [4, 8], [6, 6]] }
    end

    it "returns hit for a valid attack" do
      put "/battleship", params: { x: 0, y: 1 }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("hit")
    end

    it "returns miss for an invalid attack" do
      put "/battleship", params: { x: 1, y: 1 }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("miss")
    end

    it "returns sunk when a ship is fully hit" do
      put "/battleship", params: { x: 0, y: 3 }
      put "/battleship", params: { x: 0, y: 2 }
      put "/battleship", params: { x: 0, y: 1 }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("sunk")
    end
  end
end
