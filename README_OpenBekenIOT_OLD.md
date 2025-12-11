# Feit Smart Dimmer 2 (2023)

Sold at costco for 40$ CAD for a 3-pack. Initially locked into the tuya ecosystem
but can be flashed with open source local automation OpenBK7231T_App firmware.

Product code: DIMSMART

FCC ID: SYW-DIMSMART

## Flash Procedure

1. Hardware tear down
   1. Disassemble device down to bare control PCB
2. Flash Module with OpenBK7231T_App firmware

   BK7231 bootloader is always active for a brief moment upon power up.
   The flashing script must be running and attached to the USB TTL uart device before the device is powered up. Best is

   1. Connect a 3.3v ttl uart to RX/TX/GND/3V3 pads on the back of the module
   2. Short pin NRST to GND for the entire duration of the flashing process
   3. Get OpenBK7231T_App firmware (old project name. Project support many chip modem and variant)

          wget https://github.com/openshwprojects/OpenBK7231T_App/releases/download/1.17.308/OpenBK7231N_QIO_1.17.308.bin

   4. Clone OpenBekenIOT hid_download_py project

          git clone https://github.com/OpenBekenIOT/hid_download_py
          python3 -m venv venv
          ./venv/bin/pip3 install -r hid_download_py/requirements.txt

   5. Flash the device

      With the usb uart ttl device plugged in and the BK7231N __not__ powered on, run

          ./venv/bin/python3 hid_download_py/uartprogram OpenBK7231N_QIO_1.17.308.bin -d /dev/cu.usb* -w -u -s 0x0

      Then apply 3v3 to the BK7231N.

      You should get

          UartDownloader....
          programm....
          Gotten Bus...   : |                                                  |[    ?k/s]caution: ignoring unexpected reply in SetBaudRate
          Write Successful: |##################################################|[ 15.0k/s]

   6.  Power cycle board by unplugging/plugging 3.3v line
3. Configure BK7231 wifi
    1.  Connect to the `OpenBK7231N_01234567` wifi ssid
    2.  Type in the wifi ssid and password you want the module to connect to
    3.  Apply
4. OpenBK7231T_App config
   1. Find device dhcp assigned ip address
   2. Connect to OpenBK7231T_App config web server at `http://<device ip>`
   3. Click `Launch Web Application` so we can edit autoexec.bat config scrip
   4. Go to `Filesystem` tab
   5. `Create file` -> `autoexec.bat` -> `OK`
   6. `List Filesystem`

      `/autoexec.bat - 0` should show up

   7. Click `/autoexec.bat` -> Paste this in multiline editor field and click `Save`

          startDriver TuyaMCU
          setChannelType 1 toggle
          setChannelType 2 dimmer
          setChannelType 4 OffDimBright
          tuyaMcu_setDimmerRange 0 1000
          linkTuyaMCUOutputToChannel 1 bool 1
          linkTuyaMCUOutputToChannel 2 val 2
          linkTuyaMCUOutputToChannel 3 val 3
          linkTuyaMCUOutputToChannel 101 enum 4

   8. Go back to main config page at `http://<device ip>`
   9. `Restart` -> `OK`

        Wait some time

        Reload page

   10. `Config` -> `Configure Startup` -> `Channel 1`: `-1` -> `Save`
   11. `Config` -> `Configure Names` -> `ShortName`: `dimmer0` -> `Full Name`: `OpenBK7231N_dimmer0` -> `Submit` -> `OK`
   12. `Config` -> `Configure MQTT` -> Fill in server and auth info -> `Group Topic`: `BK7231N` -> `Submit`
   13. `Config` -> `Change Startup Command Test` -> `Startup command`: `scheduleHADiscovery 10` -> `Submit`

        Needed so change of ip address is reported to HomeAssistant

   14. `Restart` -> `OK`
   15. Confirm device is discovered by Home Assistant
5. Hardware re-assembly
   1. Put back together the device
6. Install dimmer in wall
   1. Turn off breaker
   2. Install dimmer in wall
   3. Turn on breaker
7. Confirm device is online in Home Assistant

# Refs

* Feit Dimmer Config https://www.elektroda.com/rtvforum/topic3949246.html
* OpenBeken Setup Guide https://www.elektroda.com/rtvforum/topic3947241.html
