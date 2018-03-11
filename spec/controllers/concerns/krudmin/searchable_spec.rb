require "rails_helper"

describe Krudmin::Searchable do

  describe described_class::PersistedSearchResults do
    let(:params) { ActionController::Parameters.new }
    let(:default_params) { {} }
    let(:cache_path) { "key" }
    let(:cache_adapter) { {} }

    subject { described_class.new(params, default_params, cache_path, cache_adapter) }

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
  end
end
