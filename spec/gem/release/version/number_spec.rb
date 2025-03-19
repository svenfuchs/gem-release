describe Gem::Release::Version::Number do
  subject { described_class.new(number, target).bump }

  describe 'given 1.0.0' do
    let(:number) { '1.0.0' }

    describe 'given target: 1.2.3' do
      let(:target) { '1.2.3' }
      it { should eq '1.2.3' }
    end

    describe 'given target: 1.2.3.pre.17' do
      let(:target) { '1.2.3.pre.17' }
      it { should eq '1.2.3.pre.17' }
    end

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
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

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
    end

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

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
    end

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

  describe 'given 1.1.1.dev.1' do
    let(:number) { '1.1.1.dev.1' }

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
    end

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

    describe 'given target: :dev' do
      let(:target) { :pre }
      it { should eq '1.1.1.pre.1' }
    end

    describe 'given target: nil (defaults to :pre)' do
      let(:target) { nil }
      it { should eq '1.1.1.dev.2' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.1.1.rc.1' }
    end
  end

  describe 'given 1.1.1-pre.1' do
    let(:number) { '1.1.1-pre.1' }

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
    end

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
      it { should eq '1.1.1-pre.2' }
    end

    describe 'given target: nil (defaults to :pre)' do
      let(:target) { nil }
      it { should eq '1.1.1-pre.2' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.1.1-rc.1' }
    end
  end

  describe 'given 1.1.1-rc.1' do
    let(:number) { '1.1.1-rc.1' }

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
    end

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
      it { should eq '1.1.1-rc.2' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.1.1-rc.2' }
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

  describe 'given 1.0.0-alpha.1' do
    let(:number) { '1.0.0-alpha.1' }

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
    end

    describe 'given target: :alpha' do
      let(:target) { :alpha }
      it { should eq '1.0.0-alpha.2' }
    end

    describe 'given target: :beta' do
      let(:target) { :beta }
      it { should eq '1.0.0-beta.1' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.0.0-pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.0.0-rc.1' }
    end
  end

  describe 'given 1.1.1.pre.1' do
    let(:number) { '1.1.1.pre.1' }

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
    end

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

  describe 'given 1.1.1-rc.1' do
    let(:number) { '1.1.1-rc.1' }

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
    end

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
      it { should eq '1.1.1-rc.2' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.1.1-rc.2' }
    end
  end

  describe 'given epoch semver 1.0.0.0' do
    let(:number) { '1.0.0.0' }

    describe 'given target: 1.2.3.9' do
      let(:target) { '1.2.3.9' }
      it { should eq '1.2.3.9' }
    end

    describe 'given target: 1.0.0.0.pre.17' do
      let(:target) { '1.0.0.0.pre.17' }
      it { should eq '1.0.0.0.pre.17' }
    end

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '2.0.0.0' }
    end

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '1.1.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1.0.1.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1.0.0.1' }
    end

    describe 'given target: nil (defaults to :patch)' do
      let(:target) { nil }
      it { should eq '1.0.0.1' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.0.1.0.pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.0.1.0.rc.1' }
    end
  end

  describe 'given epoch semver 1.2.0.0' do
    let(:number) { '1.2.0.0' }

    describe 'given target: 1.2.3.9' do
      let(:target) { '1.2.3.9' }
      it { should eq '1.2.3.9' }
    end

    describe 'given target: 1.2.0.0.pre.17' do
      let(:target) { '1.2.0.0.pre.17' }
      it { should eq '1.2.0.0.pre.17' }
    end

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '2.0.0.0' }
    end

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '1.3.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1.2.1.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1.2.0.1' }
    end

    describe 'given target: nil (defaults to :patch)' do
      let(:target) { nil }
      it { should eq '1.2.0.1' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.2.1.0.pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.2.1.0.rc.1' }
    end
  end

  describe 'given epoch semver 1.2.3.0' do
    let(:number) { '1.2.3.0' }

    describe 'given target: 1.2.3.9' do
      let(:target) { '1.2.3.9' }
      it { should eq '1.2.3.9' }
    end

    describe 'given target: 1.2.3.0.pre.17' do
      let(:target) { '1.2.3.0.pre.17' }
      it { should eq '1.2.3.0.pre.17' }
    end

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '2.0.0.0' }
    end

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '1.3.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1.2.4.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1.2.3.1' }
    end

    describe 'given target: nil (defaults to :patch)' do
      let(:target) { nil }
      it { should eq '1.2.3.1' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.2.4.0.pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.2.4.0.rc.1' }
    end
  end

  describe 'given epoch semver 1.2.3.4' do
    let(:number) { '1.2.3.4' }

    describe 'given target: 1.2.3.9' do
      let(:target) { '1.2.3.9' }
      it { should eq '1.2.3.9' }
    end

    describe 'given target: 1.2.3.4.pre.17' do
      let(:target) { '1.2.3.4.pre.17' }
      it { should eq '1.2.3.4.pre.17' }
    end

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '2.0.0.0' }
    end

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '1.3.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1.2.4.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1.2.3.5' }
    end

    describe 'given target: nil (defaults to :patch)' do
      let(:target) { nil }
      it { should eq '1.2.3.5' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1.2.4.0.pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1.2.4.0.rc.1' }
    end
  end

  describe 'given epoch semver 1001.1.1' do
    let(:number) { '1001.1.1' }

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '2000.0.0' }
    end

    describe 'given target: :major' do
      let(:target) { :major }
      it { should eq '1002.0.0' }
    end

    describe 'given target: :minor' do
      let(:target) { :minor }
      it { should eq '1001.2.0' }
    end

    describe 'given target: :patch' do
      let(:target) { :patch }
      it { should eq '1001.1.2' }
    end

    describe 'given target: nil (defaults to :patch)' do
      let(:target) { nil }
      it { should eq '1001.1.2' }
    end

    describe 'given target: :pre' do
      let(:target) { :pre }
      it { should eq '1001.2.0.pre.1' }
    end

    describe 'given target: :rc' do
      let(:target) { :rc }
      it { should eq '1001.2.0.rc.1' }
    end
  end

  describe 'given 1.0' do
    let(:number) { '1.0' }

    describe 'given target: 1.2.3' do
      let(:target) { '1.2.3' }
      it { should eq '1.2.3' }
    end

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
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

  describe 'given 1' do
    let(:number) { '1' }

    describe 'given target: 1.2.3' do
      let(:target) { '1.2.3' }
      it { should eq '1.2.3' }
    end

    describe 'given target: :epoch' do
      let(:target) { :epoch }
      it { should eq '1000.0.0' }
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

  describe 'given A' do
    let(:number) { 'A' }
    let(:target) { :major }
    it { expect { subject }.to raise_error(Gem::Release::Abort, 'Cannot parse version number A') }
  end
end
