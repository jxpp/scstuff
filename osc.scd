s.boot;

~oscAddress = NetAddr.new("127.0.0.1", 5005);
~array = Int8Array.fill(2, {0});
~array[0] = 1
~array[1] = 2
~oscAddress.sendMsg("/logvolume", 2, 3);