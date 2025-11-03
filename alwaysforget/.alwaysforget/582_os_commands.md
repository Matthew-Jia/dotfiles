
## Mount a shared directory
sudo modprobe 9pnet_virtio
sudo modprobe 9p
sudo mkdir -p /mnt/mac
sudo mount -t 9p -o trans=virtio,version=9p2000.L share /mnt/mac

## rsync MAC -> VM
rsync -av --delete \
  --exclude='.git' \
  /mnt/mac/linux-editable/ ~/linux/
