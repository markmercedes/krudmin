require 'spec_helper'

require_relative '../../../lib/krudmin/navigation_items'

describe Krudmin::NavigationItems do
  before do
    stuff = double(link: :link, links_path: :links_path, new_link_path: :new_link_path)
    allow_any_instance_of(Krudmin::NavigationItems).to receive(:routes).and_return(stuff)
    allow_any_instance_of(Krudmin::NavigationItems::Node).to receive(:routes).and_return(stuff)
    allow(Krudmin::NavigationItems::Node).to receive(:routes).and_return(stuff)
  end

  let(:items) {
    [
      Krudmin::NavigationItems::Node.new(:label, :link),
      Krudmin::NavigationItems::Node.new(:label, :link, visible_if: -> { false }),
    ]
  }

  subject { described_class.new(items: items) }

  it 'only exposes visible items' do
    expect(subject.to_a.size).to be 1
  end

  describe Krudmin::NavigationItems::Node do
    subject { described_class.new("Link Label", "My Link", icon: :iconName) }

    describe "visibility permissions" do
      describe "single node" do
        subject { described_class.new("Link Label", "My Link", icon: :iconName, visible_if: visibility_proc ) }

        context "not visible" do
          let(:visibility_proc) { -> { false } }

          it "has an invisible state" do
            expect(subject).not_to be_visible
          end
        end

        context "visible" do
          let(:visibility_proc) { -> { true } }

          it "has a visible state" do
            expect(subject).to be_visible
          end
        end
      end

      describe "management node" do
        context "default" do
          subject { described_class.node_for("Link Label", "link") }

          it "has everything as visible" do
            expect(subject).to be_visible
            expect(subject.map(&:label)).to eq(["Manage", "Add"])
          end
        end

        subject { described_class.node_for("Link Label", "link", visible_if: visibility_proc, icon: :iconName, manage_if: manage_visibility_proc, add_if: add_visibility_proc) }

        context "not visible" do
          let(:visibility_proc) { -> { false } }

          context "visible_if if false" do
            let(:manage_visibility_proc) { -> { true } }
            let(:add_visibility_proc) { -> { true } }

            it "has an invisible state" do
              expect(subject).not_to be_visible
            end
          end

          context "visible_if if true but children nodes are false" do
            let(:visibility_proc) { -> { true } }
            let(:manage_visibility_proc) { -> { false } }
            let(:add_visibility_proc) { -> { false } }

            it "has an invisible state" do
              expect(subject).not_to be_visible
            end
          end
        end

        context "visible" do
          let(:visibility_proc) { -> { true } }

          context "visible_if if true and at least one children is visible" do
            context "able to manage" do
              let(:manage_visibility_proc) { -> { true } }
              let(:add_visibility_proc) { -> { false } }

              it "has an invisible state" do
                expect(subject).to be_visible
                expect(subject.map(&:label)).to eq(["Manage"])
              end
            end

            context "able to add" do
              let(:manage_visibility_proc) { -> { false } }
              let(:add_visibility_proc) { -> { true } }

              it "has an invisible state" do
                expect(subject).to be_visible
                expect(subject.map(&:label)).to eq(["Add"])
              end
            end
          end
        end
      end
    end

    describe "plain properties" do
      it {
        expect(subject.label).to eql("Link Label")
        expect(subject.link).to eql("My Link")
        expect(subject.icon).to eql(:iconName)
        expect(subject.label_class).to eql("menu-node-link-label")
        expect(subject.visible_if.call).to be_truthy
      }
    end

    describe "exposed children items" do
      let(:items) {
        [
          described_class.new(:label, :link),
          described_class.new(:label, :link, visible_if: -> { false }),
        ]
      }

      let(:root_node) { described_class.new(:label, :link, items: items) }

      it 'only exposes visible items' do
        expect(root_node.to_a.size).to be 1
      end
    end
  end
end
