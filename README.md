# tasker

## Service

```
sudo ln -s /opt/tasker/tasker.service /etc/systemd/system/tasker.service
sudo systemctl daemon-reload
sudo systemctl enable tasker.service
sudo systemctl start tasker.service


sudo journalctl -u tasker.service -n 50
sudo journalctl -u tasker.service -f
```