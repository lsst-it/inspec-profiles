control "atarchiver_mounts" do
  title "atarchiver NFS mounts"
  only_if { sys_info.fqdn == 'atarchiver.cp.lsst.org' }

  describe mount("/net/lsstdata") do
    its(:options) { should include "rw" }
    its(:type) { should eq 'nfs4' }
  end

  describe mount("/net/project") do
    its(:options) { should include "rw" }
    its(:type) { should eq 'nfs4' }
  end

  describe mount("/net/scratch") do
    its(:options) { should include "rw" }
    its(:type) { should eq 'nfs4' }
  end
end
