control 'ccs-vw-network' do
  describe host('ts-csc-generic-01.cp.lsst.org') do
    it { should be_resolvable }
    it { should be_reachable }
  end

  describe host('atsccs1.cp.lsst.org') do
    it { should be_resolvable }
    it { should be_reachable }
  end

  describe host('atsdaq1.cp.lsst.org') do
    it { should be_resolvable }
    it { should be_reachable }
  end
end

control 'users' do
  allowed_users = %w[nfsnobody jhoblitt_b athebo_b]

  users.where { uid > 1000 && !allowed_users.include?(username) }.usernames.each do |username|
    describe user(username) do
      it { should_not exist }
    end
  end
end
