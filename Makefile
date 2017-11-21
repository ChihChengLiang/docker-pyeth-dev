setup:
	docker build -t localethereum/pyethapp-dev .
setup27:
	docker build -f Dockerfile-py27 -t localethereum/pyethapp-dev27 .

init-config:
	sh start.sh
	cp docker-compose.default.yml docker-compose.yml

init-source:
	mkdir shared_data
	test -d ./shared_data/pydevp2p || git clone https://github.com/ethereum/pydevp2p.git --branch develop ./shared_data/pydevp2p
	test -d ./shared_data/pyethapp || git clone https://github.com/ethereum/pyethapp.git --branch develop ./shared_data/pyethapp
	test -d ./shared_data/pyethereum || git clone https://github.com/ethereum/pyethereum.git --branch develop ./shared_data/pyethereum
	test -d ./shared_data/sharding || git clone https://github.com/ethereum/sharding.git --branch develop ./shared_data/sharding
	cd ./shared_data/pyethereum && git submodule init && git submodule update --recursive

rebuild-boot-all:
	docker exec bootstrap bash -c "cd /pyeth/pydevp2p && python setup.py install"
	docker exec bootstrap bash -c "cd /pyeth/pyethereum && python setup.py install"
	docker exec bootstrap bash -c "cd /pyeth/sharding && pip install -r requirements.txt"
	docker exec bootstrap bash -c "cd /pyeth/pyethapp && python setup.py install"
rebuild-miner-all:
	docker exec miner bash -c "cd /pyeth/pydevp2p && python setup.py install"
	docker exec miner bash -c "cd /pyeth/pyethereum && python setup.py install"
	docker exec miner bash -c "cd /pyeth/sharding && pip install -r requirements.txt"
	docker exec miner bash -c "cd /pyeth/pyethapp && python setup.py install"
rebuild-miner27-all:
	docker exec miner-py27 bash -c "cd /pyeth/pydevp2p && python setup.py install"
	docker exec miner-py27 bash -c "cd /pyeth/pyethereum && python setup.py install"
	docker exec miner-py27 bash -c "cd /pyeth/sharding && pip install -r requirements.txt"
	docker exec miner-py27 bash -c "cd /pyeth/pyethapp && python setup.py install"

run-boot:
	docker exec bootstrap bash -c "pyethapp --password /root/.config/pyethapp/password.txt -l :info,eth:debug,pow:debug  --log-file /root/log/log.txt run &"
run-miner:
	docker exec miner bash -c "pyethapp -m 50 --password /root/.config/pyethapp/password.txt -l :info,eth:debug,pow:debug --log-file  /root/log/log.txt run &"

clear-boot:
	docker exec bootstrap bash -c "rm -r /root/.config/pyethapp/leveldb/"
clear-miner:
	docker exec miner bash -c "rm -r /root/.config/pyethapp/leveldb/"
