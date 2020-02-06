control 'home_mounts' do
  describe mount("/net/home") do
    its(:options) { should include "rw" }
    its(:type) { should eq 'nfs4' }
  end
end
