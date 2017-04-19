describe Gem::Release::Version::Number do
  subject { described_class.new(number, target).bump }

  describe 'given 1.0.0' do
    let(:number) { '1.0.0' }

    describe 'given target: 1.2.3' do
      let(:target) { '1.2.3' }
      it { should eq '1.2.3' }
    end

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '2.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1.1.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1.0.1' }
    end

    describe 'given target: nil (defaults to :patch)' do
      let(:target) { nil }
      it { should eq '1.0.1' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.1.0.pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.1.0.rc.1' }
    end
  end

  describe 'given 1.1.0' do
    let(:number) { '1.1.0' }

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '2.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1.2.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1.1.1' }
    end

    describe 'given target: nil (defaults to :patch)' do
      let(:target) { nil }
      it { should eq '1.1.1' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.2.0.pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.2.0.rc.1' }
    end
  end

  describe 'given 1.1.1' do
    let(:number) { '1.1.1' }

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '2.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1.2.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1.1.2' }
    end

    describe 'given target: nil (defaults to :patch)' do
      let(:target) { nil }
      it { should eq '1.1.2' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.2.0.pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.2.0.rc.1' }
    end
  end

  describe 'given 1.1.1.pre.1' do
    let(:number) { '1.1.1.pre.1' }

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '2.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1.2.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1.1.1' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.1.1.pre.2' }
    end

    describe 'given target: nil (defaults to :pre)' do
      let(:target) { nil }
      it { should eq '1.1.1.pre.2' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.1.1.rc.1' }
    end
  end

  describe 'given 1.1.1.rc.1' do
    let(:number) { '1.1.1.rc.1' }

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '2.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1.2.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1.1.1' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { expect { subject }.to raise_error('Cannot go from an rc version to a pre version') }
    end

    describe 'given target: nil (defaults to :rc)' do
      let(:target) { nil }
      it { should eq '1.1.1.rc.2' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.1.1.rc.2' }
    end
  end

  describe 'given 1.0.0.alpha.1' do
    let(:number) { '1.0.0.alpha.1' }

    describe 'given target: :alpha' do
      let(:target) { :alpha }
      it { should eq '1.0.0.alpha.2' }
    end

    describe 'given target: :beta' do
      let(:target) { :beta }
      it { should eq '1.0.0.beta.1' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.0.0.pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.0.0.rc.1' }
    end
  end
end
