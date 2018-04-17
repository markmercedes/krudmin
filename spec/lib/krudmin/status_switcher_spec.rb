require "spec_helper"
require "#{Dir.pwd}/lib/krudmin/status_switcher"

describe Krudmin::StatusSwitcher do
  let(:controller) { double() }
  let(:context) { :list }
  let(:model_label) { "Mocked Model Label" }

  subject { described_class.new(controller, model, model_label, context: context) }

  context "successful operations" do
    let(:model) { double("activate!" => true, "deactivate!" => true) }
    let(:format_responder) do
      OpenStruct.new(
        js: -> { controller.render partial_name },
        html: -> { controller.redirect_to controller.resource_root }
      )
    end

    before do
      expect(controller).to receive(:respond_to) { format_responder }
    end

    describe "switch_on" do
      let(:partial_name) { "activate" }

      context "html" do
        it do
          expect(controller).to receive(:resource_root) { "resource_root" }
          expect(controller).to receive(:redirect_to).with("resource_root")

          subject.call(:on).html.call
        end
      end

      context "js" do
        it do
          expect(controller).to receive(:render).with("activate")

          subject.call(:on).js.call
        end
      end
    end

    describe "switch_off" do
      let(:partial_name) { "deactivate" }

      context "html" do
        it do
          expect(controller).to receive(:resource_root) { "resource_root" }
          expect(controller).to receive(:redirect_to).with("resource_root")

          subject.call(:off).html.call
        end
      end

      context "js" do
        it do
          expect(controller).to receive(:render).with("deactivate")

          subject.call(:off).js.call
        end
      end
    end
  end

  context "unsuccessful operations" do
    let(:model) { double("activate!" => false, "deactivate!" => false) }
    let(:format_responder) do
      OpenStruct.new(
        js: -> { controller.render partial_name },
        html: -> { controller.redirect_to controller.resource_root }
      )
    end

    before do
      expect(controller).to receive(:respond_to) { format_responder }
    end

    describe "switch_on" do
      let(:partial_name) { "activate" }

      context "html" do
        it do
          expect(controller).to receive(:resource_root) { "resource_root" }
          expect(controller).to receive(:redirect_to).with("resource_root")

          subject.call(:on).html.call
        end
      end

      context "js" do
        it do
          expect(controller).to receive(:render).with("activate")

          subject.call(:on).js.call
        end
      end
    end

    describe "switch_off" do
      let(:partial_name) { "deactivate" }

      context "html" do
        it do
          expect(controller).to receive(:resource_root) { "resource_root" }
          expect(controller).to receive(:redirect_to).with("resource_root")

          subject.call(:off).html.call
        end
      end

      context "js" do
        it do
          expect(controller).to receive(:render).with("deactivate")

          subject.call(:off).js.call
        end
      end
    end
  end
end
