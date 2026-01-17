import std.stdio;
import std.socket;
import std.algorithm;
import std.array;
import std.string;
import std.conv;
import consolecolors;
import core.time;

string[] history; //TODO

void main(string[] args) {
	enableConsoleUTF8(); /* Required for correct operation on Windows */
	if (args.length <= 1) {
		shell();
	} else {
		if (args[1] == "-q") {
        		quick(args);
        	} else {
        		writeln("Arguments not recognized.");
        	}
        }
}

void uerr(string error, char type) {
	switch (type) {
		case 'e':
			cwritefln("udpping: <b><red>Error:</red> %s</b>", error);
			break;
		case 'i':
			cwritefln("udpping: <b><cyan>Hint:</cyan> %s</b>", error);
			break;
		case 's':
			cwritefln("udpping: <b><lgreen>Success!</lgreen></b>");
			break;
		default:
			return;
	}
}

int quick(string[] args) {
	cwritefln("<b>Quick UdpPing</b>:<b><grey> v0.1.5</grey></b>");
	
	if (args.length < 6) {
		uerr("Not enough arguments.", 'e');
		return(-1);
	}
	
	if (!(args[2] == "-a" || args[2] == "--address")) {
		uerr("Incorrect usage.", 'e');
		uerr("The second argument must be -a [address:port] or --address [address:port]!", 'i');
		return(-1);
	}
	
	if (!(args[4] == "-s" || args[4] == "--send")) {
		uerr("Incorrect usage.", 'e');
		uerr("The third argument must be -s [message] or --send [message]!", 'i');
		return(-1);
	}
	
	string[] tmp = args[3].split(":");
	auto udps = new UdpSocket();
        auto addr = new InternetAddress(std.socket.InternetAddress.parse(tmp[0]), to!ushort(tmp[1]));
	udps.connect(addr);
        udps.send(args[5]);
        uerr("", 's');
	return(0);
}

void shell() {
	cwritefln("<b>UdpPing Console</b>:<b><grey> v0.1.5 BETA</grey></b>");
	auto udps = new UdpSocket();
	udps.setOption(SocketOptionLevel.SOCKET, SocketOption.RCVTIMEO, 5.seconds);
        InternetAddress addr = null;
        bool gogo = true;

        while (gogo) {
        	write("[udpping] > ");
		stdout.flush();
                string[] input = (stdin.readln().strip()).split();
                switch (input[0]) {
                        case "exit":
                                gogo = false;
                                break;
                        case "connect":
                                if (input.length == 2) {
                                	auto tmp = input[1].findSplit(":");
                                	if (tmp[2] != "") {
                                		addr = new InternetAddress(std.socket.InternetAddress.parse(tmp[0].strip()), to!ushort(tmp[2].strip()));
                                		udps.connect(addr);
                                		uerr("", 's');
					} else {
						uerr("Incorrect usage.", 'e');
						uerr("Address must be in the format ip:port!", 'i');
					}
                                } else {
                                	write("UDP server address: ");
					stdout.flush();
                                	auto tmp = (stdin.readln().strip()).findSplit(":");
                                	if (tmp[2] != "") {
                                		addr = new InternetAddress(std.socket.InternetAddress.parse(tmp[0].strip()), to!ushort(tmp[2].strip()));
                                		udps.connect(addr);
                                		uerr("", 's');
                                	} else {
                                		uerr("Incorrect usage.", 'e');
						uerr("Address must be in the format ip:port!", 'i');
                                	}
                                }
                                break;
                        case "send":
                        	if (addr is null) {
                        		uerr("Command was used before connecting to the UDP server!", 'e');
                        		uerr("First, use the \"connect\" command", 'i');
                        		break;
                        	}
                        	
                        	string tmp = "";
                        	
                                if (input.length >= 2) {
					for (int i = 1; i < input.length; i++) {
						if (i != 1) {
							tmp = tmp ~ " ";
						}
						tmp = tmp ~ input[i];
					}
                                } else {
                                	write("Message: ");
					stdout.flush();
                                	tmp = stdin.readln().strip();
                                }
                                
                                udps.send(tmp);
                                uerr("", 's');
                                break;
                        case "sendw":
                        	if (addr is null) {
                        		uerr("Command was used before connecting to the UDP server!", 'e');
                        		uerr("First, use the \"connect\" command", 'i');
                        		break;
                        	}
                        	
                                string tmp = "";
                        	
                                if (input.length >= 2) {
					for (int i = 1; i < input.length; i++) {
						if (i != 1) {
							tmp = tmp ~ " ";
						}
						tmp = tmp ~ input[i];
					}
                                } else {
                                	write("Message: ");
					stdout.flush();
                                	tmp = stdin.readln().strip();
                                }
                                udps.send(tmp);
                                
                                cwritef("<b>Waiting for a response...</b> ");
                                stdout.flush();
                                
                                ubyte[1024] buf;
                                long received = udps.receive(buf[]);
                                
                                if (received <= 0) {
                                	if (received == 0) {
                                		uerr("connection closed", 'e');
                                	} else {
                                		uerr("receive error", 'e');
                                	}
                                	break;
                                }
                                
                                auto data = buf[0..cast(size_t)received];
                                writeln("DEBUG: Raw bytes = ", data); 
                                string response = cast(string)data;
                                writeln(response.strip());
                                
                                uerr("", 's');
                                break;
                        case "help":
                                cwritefln("<b>Commands:\n  connect [address:port]</b> - Connects to a UDP server.  If no address is provided, the program will prompt you. <b><red>USE BEFORE \"send\"!</red>\n  send [message]</b> - Sends a message to the connected UDP server. <b><red>USE AFTER \"connect\"!</red>\n  sendw [message]</b> - does the same as send, but also waits for a response from the server. <b><red>USE AFTER \"connect\"!</red>\n  ver</b> - Displays the UdpPing Console version.\n  <b>exit</b> - Exits the UdpPing Console.");
                                break;
                        case "ver":
                                cwritefln("<b>UdpPing Console</b>:<b><grey> v0.1.4</grey></b>");
                                break;
                        
                        default:
                                uerr("Unknown command: \"" ~ input[0] ~ "\"", 'e');
                }
        }
}
