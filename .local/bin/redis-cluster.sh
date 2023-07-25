#!/bin/sh
# Starts redis in cluster mode from using single or multiple ports

echo "Do you want to run single port Redis or multiple? (s/m)"
read mode

if [ "$mode" = "s" ]; then
    echo "Enter the port number:"
    read port
    PORTS=($port)
elif [ "$mode" = "m" ]; then
    echo "Enter the start port:"
    read start
    echo "Enter the end port:"
    read end
    PORTS=($(seq $start 1 $end))
else
    echo "Invalid input. Please enter s or m."
    exit 1
fi

base_dir="$HOME/redis-cluster"
mkdir -p "$base_dir"
cd "$base_dir"

# set up servers
rm -f "$base_dir/appendonly.aof"
rm -f "$base_dir/dump.rdb"
for i in ${PORTS[@]}
do
    node_dir="$base_dir/$i"
    rm -rf $node_dir
    mkdir $node_dir
    touch $node_dir/redis.conf
    touch $node_dir/nodes.conf
    echo "port $i
cluster-enabled yes
cluster-config-file $node_dir/nodes.conf
cluster-node-timeout 5000
appendonly yes" >> $node_dir/redis.conf
done

session_name="redis-cluster"

# Kill existing session
tmux kill-session -t "$session_name"

# set up individual redis
tmux new-session -d -s "$session_name" -n "$session_name"

# Stopping existing redis servers
killall redis-server

# Start redis servers in cluster mode
for i in ${PORTS[@]}
do
   node_dir="$base_dir/$i"
   tmux send-keys "redis-server $node_dir/redis.conf" Enter
   tmux split-window -h
   tmux select-layout tiled
done

# Connect to redis cluster using redis-cli
if [ "$mode" = "s" ]; then
    tmux send-keys "redis-cli -c -p ${PORTS[0]}" Enter
elif [ "$mode" = "m" ]; then
    CMD="redis-cli --cluster create"
    for i in ${PORTS[@]}; do CMD+=" 127.0.0.1:$i"; done
    CMD+=" --cluster-replicas 1 --cluster-yes"
    tmux send-keys "$CMD" Enter
fi

# attach session
tmux -2 attach-session -d
