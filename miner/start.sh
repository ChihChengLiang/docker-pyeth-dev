echo "BOOTSTRAP_NODE is $BOOTSTRAP_NODE"
if [ -z "$BOOTSTRAP_NODE" ]; then echo "BOOTSTRAP_NODE must be set" && exit 1; fi
head -1 /dev/random | shasum -a 256 > /root/.config/pyethapp/privkey.hex
export PRIVKEY=`cat /root/.config/pyethapp/privkey.hex | awk '{print $1}'`
echo "Generated random private key: $PRIVKEY" 
perl -pi -e "s/PRIVKEY/$PRIVKEY/" /root/.config/pyethapp/config.yaml
echo "Creating new account"
/usr/local/bin/pyethapp --password /root/.config/pyethapp/password.txt account new
echo "Launching node"
/usr/local/bin/pyethapp -m 50 -l :info,eth:debug,pow:debug --log-file /root/log/log.txt -b $BOOTSTRAP_NODE run 
