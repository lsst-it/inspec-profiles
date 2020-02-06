control "atarchiver_mounts" do
  title "atarchiver NFS mounts"
  only_if { command('hostname').stdout =~ /^atarchiver.cp.lsst.org/ }

  describe mount("/net/lsstdata") do
    its(:options) { should include "rw" }
    its(:type) { should eq 'nfs4' }
  end

  describe mount("/net/project") do
    it { should_not be_mounted }
  end

  describe mount("/net/scratch") do
    it { should_not be_mounted }
  end
end
