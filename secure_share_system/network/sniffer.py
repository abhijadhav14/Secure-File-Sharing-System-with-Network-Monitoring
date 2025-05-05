from scapy.all import sniff

def packet_callback(packet):
    if packet.haslayer('IP'):
        print(f"[!] Packet: {packet['IP'].src} -> {packet['IP'].dst}")

def start_sniffing():
    sniff(prn=packet_callback, store=0)

if __name__ == "__main__":
    start_sniffing()