echo "starting docker.."
/usr/local/bin/docker-compose up -d --remove-orphans

echo "wait for 2s"
sleep 2s

echo "add bootstrap node"
/usr/local/bin/docker-compose exec -T daemon ipfs bootstrap list
/usr/local/bin/docker-compose exec -T daemon ipfs bootstrap add /ip4/13.251.178.212/tcp/4001/p2p/QmSs2hiRANfsngEaNWe6ApJdRQjuXZeMcMVDtwKbq3rh6y
