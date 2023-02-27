attach:
	docker-compose exec geth geth --datadir /data attach

peers:
	docker-compose exec geth geth --datadir /data attach --exec admin.peers
	docker-compose exec geth geth --datadir /data attach --exec net.peerCount

sh1:
	docker-compose exec geth sh

sh2:
	docker-compose exec prysm bash

run:
	docker-compose up -d
	docker-compose logs --tail=100 -f
