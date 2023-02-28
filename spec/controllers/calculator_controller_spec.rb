require 'rails_helper'

RSpec.describe CalculatorController, type: :controller do
  # describe "GET#index" do
  #   it "renders the index template" do
  #     get :index
  #     expect(response).to render_template(:index)
  #   end
    
  #   it "assigns all calculations to @calculations" do
  #     calculation = {num1: 1, num2: 2, operator: "+", result: 3, count: 1}
  #     $collection.insert_one(calculation)

  #     get :index
  #     expect(assigns(:calculations)).to eq([calculation])
  #   end
  # end

  describe "POST#calculate" do
    context "with valid input" do
      let(:num1) { "1" }
      let(:num2) { "2" }
      let(:operator) { "+" }
    end

    context "with invalid input" do
      let(:num1) { "0" }
      let(:num2) { "2" }
      let(:operator) { "+" }

      it "redirects to the root path with an alert" do
        post :calculate, params: { num1: num1, num2: num2, operator: operator }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Error: input must be between 1 and 100")
      end

      it "does not add the calculation to the database" do
        expect {
          post :calculate, params: { num1: num1, num2: num2, operator: operator }
        }.not_to change { $collection.count_documents({}) }
      end
    end
    

    context 'when valid input is given' do
      before do
        post :calculate, params: { num1: 2, num2: 3, operator: '+' }, xhr: true
      end

      it 'should return a successful response' do
        expect(response).to be_successful
      end
    end

    context "when input is negative" do
      let(:num1) { "-1" }
      let(:num2) { "2" }
      let(:operator) { "+" }

      it "redirects to the root path with an alert" do
        post :calculate, params: { num1: num1, num2: num2, operator: operator }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Error: input must be between 1 and 100")
      end

      it "does not add the calculation to the database" do
        expect {
          post :calculate, params: { num1: num1, num2: num2, operator: operator }
        }.not_to change { $collection.count_documents({}) }
      end
    end

    context "when input is greater than 100" do
      let(:num1) { "101" }
      let(:num2) { "2" }
      let(:operator) { "+" }

      it "redirects to the root path with an alert" do
        post :calculate, params: { num1: num1, num2: num2, operator: operator }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Error: input must be between 1 and 100")
      end

      it "does not add the calculation to the database" do
        expect {
          post :calculate, params: { num1: num1, num2: num2, operator: operator }
        }.not_to change { $collection.count_documents({}) }
      end
    end

    context "when input is a float" do
      let(:num1) { "1.5" }
      let(:num2) { "2" }
      let(:operator) { "+" }

      it "does not add the calculation to the database" do
        expect {
          post :calculate, params: { num1: num1, num2: num2, operator: operator }
        }.not_to change { $collection.count_documents({}) }
      end
    end


    context "with missing input" do
      let(:num1) { "1" }
      let(:operator) { "+" }

      it "does not add the calculation to the database" do
        expect {
          post :calculate, params: { num1: num1, operator: operator }
        }.not_to change { $collection.count_documents({}) }
      end
    end

    context "with invalid operator" do
      let(:num1) { "1" }
      let(:num2) { "2" }
      let(:operator) { "x" }

      it "does not add the calculation to the database" do
        expect {
          post :calculate, params: { num1: num1, num2: num2, operator: operator }
        }.not_to change { $collection.count_documents({}) }
      end
    end

    context "when fetching an existing calculation" do
      let(:num1) { "1" }
      let(:num2) { "2" }
      let(:operator) { "+" }
      let(:result) { 3 }

      before do
        $collection.insert_one({ num1: num1.to_f, num2: num2.to_f, operator: operator, result: result, count: 1 })
      end
    end
  end
end
