require "rails_helper"

describe Krudmin::Searchable do
  describe "input_params" do

    subject { Krudmin::ApplicationController.new }

    before do
      allow(subject).to receive(:params) { params }
    end

    let(:params) do
      ActionController::Parameters.new({
        q: { "key" => "one" },
        o: { "key" => "two" },
      })
    end

    it "merges the contents of the previous params with new params" do
      expect(subject.input_params.to_h).to eq({ "key"=>"one" })
    end
  end

  describe described_class::PersistedSearchResults do
    let(:params) { ActionController::Parameters.new }
    let(:default_params) { {} }
    let(:cache_path) { "key" }
    let(:cache_adapter) { {} }
    let(:reset_cache) { false }

    subject { described_class.new(params, default_params, cache_path, cache_adapter, reset_cache) }

    context "defaults" do
      describe "to_h" do
        it do
          expect(subject.to_h).to eq({})
        end
      end
    end

    context "with defined search params" do
      describe "to_h" do
        context "with provided params" do
          let(:params) { ActionController::Parameters.new("foo" => "bar").permit! }

          it do
            expect(subject.to_h).to eq( "foo" => "bar" )
            expect(cache_adapter["krudmin_search_results"]).to eq("{\"key\":{\"foo\":\"bar\"}}")
          end
        end

        context "with no provided params and has default params" do
          let(:params) { ActionController::Parameters.new }
          let(:default_params) { { "foo" => "bar" } }

          it "uses the values from default params" do
            expect(subject.to_h).to eq( "foo" => "bar" )
            expect(cache_adapter["krudmin_search_results"]).to eq("{\"key\":{\"foo\":\"bar\"}}")
          end
        end

        context "with cached values and no params given" do
          let(:params) { ActionController::Parameters.new }
          let(:cache_adapter) { { "krudmin_search_results" => "{\"key\":{\"foo\":\"bar\"}}" } }

          it "uses the cached values" do
            expect(subject.to_h).to eq( "foo" => "bar" )
            expect(cache_adapter["krudmin_search_results"]).to eq("{\"key\":{\"foo\":\"bar\"}}")
          end
        end
      end
    end

    describe "reset cache" do
      context "default with no reset indication provided" do
        let(:cache_adapter) { { "krudmin_search_results" => "{\"key\":{\"foo\":\"bar\"}}" } }

        it "uses the cached params in case new params aren't provided" do
          expect(subject.to_h).to eq("foo"=>"bar")
        end
      end

      context "when reset is indicated" do
        let(:reset_cache) { true }
        let(:params) { ActionController::Parameters.new }
        let(:cache_adapter) { { "krudmin_search_results" => "{\"key\":{\"foo\":\"bar\"}}" } }

        it "ignores the cached values and uses the default search params" do
          expect(subject.to_h).to eq({})
        end
      end
    end
  end
end
