# Feit Smart Dimmer 2 (2023)

Sold at costco for 40$ CAD for a 3-pack. Initially locked into the tuya ecosystem
but can be flashed with open source local automation esphome firmware.

Product code: DIMSMART

FCC ID: SYW-DIMSMART

## Project setup

```sh
uvx esphome compile generic.yaml
```

## Convertion Procedure

1. Hardware tear down
   1. Disassemble device down to bare control PCB
2. Flash Module with ESPHome firmware

   The BK7231 bootloader is always active for a brief moment upon power up.

   The flashing script must be running and attached to the USB TTL uart device before the device is powered up.

   It's easier to use CEN and catch the bootloader on reset than trying to catch it on powerup.

   1. Connect a 3.3v ttl uart to RX/TX/GND/3V3 pads on the back of the module - BUT DONT POWER UP YET
      1. Uart RX -> dimmer TX1
      2. Uart TX -> dimmer RX1
      3. Uart GND -> dimmer GND
      4. Uart GND -> dimmer NRST
      5. Uart 3v3 -> dimmer 3v3
      6. Uart GND -> dimmer CEN (do not connect yet)
   2. Short pin NRST to GND for the entire duration of the flashing process
   3. Run `uvx esphome run generic.yaml`
   4. While esphome is trying to establish communication with the the bk7231, reboot the uC by momentarily connecting CEN to GND
   5. Device should now flash and reboot

## Update procedure

### Dimmer is connected to wifi

1. Find device ip
2. `uvx esphome run generic.yaml --device 10.2.1.x`


### `feitdimmer` SSID

Happens if the device is unconfigured or can't connect to an ap.

1. Build `.bin` firmware with `./build_esphome_bin.sh`
2. Power cycle switch using tab below switch paddle
3. Wait for device to expose SSID `feitdimmer`.
4. Connect to `feitdimmer` SSID
5. Navigate to http://192.168.4.1/
6. Upload `generic-firmware.bin.gz`
