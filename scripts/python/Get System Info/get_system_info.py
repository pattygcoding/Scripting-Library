import platform
import psutil

def get_system_info():
    info = {
        'platform': platform.system(),
        'platform-release': platform.release(),
        'platform-version': platform.version(),
        'architecture': platform.machine(),
        'hostname': platform.node(),
        'ip-address': psutil.net_if_addrs()['Ethernet'][0].address,
        'mac-address': psutil.net_if_addrs()['Ethernet'][0].address,
        'processor': platform.processor(),
        'ram': str(round(psutil.virtual_memory().total / (1024.0 **3)))+" GB"
    }
    return info

for k, v in get_system_info().items():
    print(f"{k}: {v}")
