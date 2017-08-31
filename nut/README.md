## Network UPS Tools for Hass.io

[Network UPS Tools](http://networkupstools.org/) can be used to control and manage several power devices like [Uninterruptible Power Supplies](https://en.wikipedia.org/wiki/Uninterruptible_power_supply). This [Hass.io](https://home-assistant.io/hassio/) plugin provides the nessecary daemon to make use of the [Home Assistant NUT Sensor](https://home-assistant.io/components/sensor.nut/).

The default configuration should work with any [usbhid-ups](http://networkupstools.org/docs/man/usbhid-ups.html) compatible UPS. They can be added to `configuration.yaml` by adding:


```
sensor
  - platform: nut
    username: nut
    password: nut
    resources:
      - ups.load
      - ups.status
      [...]


```

The resources vary depending on your UPS vendor/model.

All supported USB UPS should work using one of the [USB drivers](http://networkupstools.org/stable-hcl.html) as well. Due to the lack of hardware some code changes might be neccessary in order to get serial or network UPS connections to work. Requests, feedback and pull request are welcome.
