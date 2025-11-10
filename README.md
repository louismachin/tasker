# tasker

## Service

```
sudo ln -s /opt/louismachin.com/louismachin.service /etc/systemd/system/louismachin.service
sudo systemctl daemon-reload
sudo systemctl enable louismachin.service
sudo systemctl start louismachin.service


sudo journalctl -u louismachin.service -n 50
sudo journalctl -u louismachin.service -f
```