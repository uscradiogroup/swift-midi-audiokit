# Moodles

This demo is a real-time music collaboration app for kids. 

---


TODO: 

1. Add Animation JSON into MIDI file. 
2. 



---


# Troubleshooting

### AQDefaultDevice Error

How to turn off this error in our console. [http://stackoverflow.com/a/40336926](http://stackoverflow.com/a/40336926)

```language-bash
2016-11-17 09:27:39.276760 Moodles[9995:323663] [aqme] 254: AQDefaultDevice (173): skipping input stream 0 0 0x0
```

1. Go to Product/Scheme/Edit Scheme
2. Select Arguments
3. Add the Environment Variable ```OS_ACTIVITY_MODE``` and set it to "disable"


### Error Domain=com.firebase Error

http://stackoverflow.com/a/39417553

If you see this error
```language-powerbash
Error Domain=com.firebase
```

Try going to your ```Target``` > ```Capabilities```, and set **Keychain Sharing** to **On**.


