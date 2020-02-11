control 'summit-core-network' do
  title "Summit core network"

  domain = 'cp.lsst.org'.freeze

  %w[core1 core2].map { |shortname| "#{shortname}.#{domain}" }.each do |fqdn|
    describe host(fqdn) do
      it { should be_resolvable }
      it { should be_reachable }
    end
  end
end

control 'bdc-core-network' do
  title "BDC core network"

  domain = 'cp.lsst.org'.freeze

  pending "BDC provisioning"

  %w[core1 core2 core3].map { |shortname| "#{shortname}.#{domain}" }.each do |fqdn|
    describe host(fqdn) do
      it { should be_resolvable }
      it { should be_reachable }
    end
  end
end

control 'core-hypervisor' do
  title "Core node hypervisor"

  describe service('libvirtd') do
    it { should be_running }
    it { should be_enabled }
  end

  describe service('iptables') do
    it { should_not be_running }
    it { should_not be_enabled }
  end

  describe filesystem("/") do
    gigabyte = 1000 * 1000
    its(:percent_free) { should be >= 50.0 }
    its(:size_kb) { should be >= 48 * gigabyte }
  end

  describe filesystem("/vm") do
    gigabyte = 1000 * 1000
    its(:percent_free) { should be >= 50.0 }
    its(:size_kb) { should be >= 450 * gigabyte }
  end

  describe mount("/vm") do
    it { should be_mounted }
    its(:device) { should eq "/dev/mapper/data-vms" }
    its(:type) { should eq 'xfs' }
  end
end

include_controls 'baseline'
