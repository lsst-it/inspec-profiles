control 'firefly_mounts' do
  title "Firefly NFS mounts"
  only_if do
    sys_info.hostname == 'ts-csc-generic-01.cp.lsst.org' || sys_info == 'nfs1.cp.lsst.org'
  end

  describe mount("/net/lsstdata") do
    its(:options) { should include "ro" }
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
