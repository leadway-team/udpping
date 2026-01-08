# UdpPing v0.1.3

A simple utility for sending requests to a UDP server.

## Compiling and Running the Application

First, clone the repository:  
`git clone https://github.com/leadway-team/udpping.git`

If you want to compile and run immediately:  
`dub run --build=release`

If you only want to compile:  
`dub build --build=release`

## Using the Application

UdpPing has two usage modes:  
1. "Quick" mode (introduced in v0.1.1)  
2. UdpPing Console (introduced in v0.1.0, expanded in v0.1.1)

### Using "Quick" Mode

The `-q` flag enables "Quick" mode.  
Immediately after it, specify either `-a [UDP server address]` or `--address [UDP server address]`.  
After the address, specify either `-s [message]` or `--send [message]`.

This will send your message to the specified UDP server.  
Example:  
`udpping -q -a 127.0.0.1:1234 -s Hello`

### Using the UdpPing Console

To enter the UdpPing Console, simply run the application without arguments.

Inside the console, the following commands are available:  
- `help` - displays help information  
- `ver` - shows the version  
- `connect [address]` - connects to a UDP server. If no address is provided, the program will prompt you.  
- `send [message]` - sends a message to the UDP server. If no address is provided, the program will prompt you.  
- `sendw [message]` - does the same as send, but also waits for a response from the server.  

Note: Use `send` before `connect`. Otherwise, the message will not be sent.

### Acknowledgments:  
1. Thanks to Grisshink  
2. Thanks to the disbanded FTeam  
