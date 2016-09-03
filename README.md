# Reboot a Linksys LRT224
Use this script to reboot a Linksys LRT224 router. Should also work on the LRT214.

## Use
1. Copy the env.template to env

   ```bash
cp env.template env
```
1. Update `env` with your username and password

   ```bash
vi ./env
```
1. Trigger the reboot

   ```bash
./router-reboot.sh
```
