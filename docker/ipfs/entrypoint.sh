echo "starting docker.."
/usr/local/bin/docker-compose up -d --remove-orphans

echo "wait for 30s"
sleep 30s

echo "add bootstrap node"
/usr/local/bin/docker-compose exec -T daemon ipfs bootstrap list
/usr/local/bin/docker-compose exec -T daemon ipfs bootstrap add /ip4/13.251.178.212/tcp/4001/p2p/QmSs2hiRANfsngEaNWe6ApJdRQjuXZeMcMVDtwKbq3rh6y

sleep 5s

echo "peering with content providers"
/usr/local/bin/docker-compose down
# patch /data/ipfs/config config.patch
/usr/local/bin/docker-compose up -d --remove-orphans
