
## Mount a shared directory
sudo modprobe 9pnet_virtio
sudo modprobe 9p
sudo mkdir -p /mnt/mac
sudo mount -t 9p -o trans=virtio,version=9p2000.L share /mnt/mac

## rsync MAC -> VM
rsync -av --delete \
  --exclude='.git' \
  /mnt/mac/linux-editable/ ~/linux/

## Set up scripts and tools

sudo apt update
sudo apt-get install -y build-essential gcc make bc flex bison \
  libncurses-dev libssl-dev libelf-dev dwarves pahole libzstd-dev python3 libnuma-dev numactl linux-intel-iotg-tools-common

find . -type f \( -name '*.sh' -o -name '*.py' \) -exec chmod 755 {} +
find scripts/ -type f -exec chmod +x {} \;

## Update OS image

cp /boot/config-$(uname -r) .config && \
make olddefconfig && \
make -j$(nproc) && \
sudo make modules_install && \
sudo make install && \
sudo update-initramfs -c -k "$(make kernelrelease)" && \
sudo update-grub && \
sudo reboot

## Update OS image to Mitosis

make mrproper && \
make x86_64_defconfig && \
scripts/kconfig/merge_config.sh -m .config mitosis.config && \
make olddefconfig && \
make -j$(nproc) && \
sudo make modules_install && \
sudo make install && \
sudo update-initramfs -c -k "$(make kernelrelease)" && \
sudo update-grub && \
sudo reboot

make -j"$(nproc)" 2>&1 | tee build.log
grep -nE "(^make(\[[0-9]+\])?: \*\*\*|error:|fatal:|undefined reference|Cannot find|No rule to make target)" build.log | head -50

## Remount case-sensitive linux-dev directory

rm -rf ~/linux-dev.sparsebundle
hdiutil create -size 40g -type SPARSEBUNDLE -fs 'Case-sensitive APFS' -volname linux-dev ~/linux-dev.sparsebundle
hdiutil attach ~/linux-dev.sparsebundle


## Enabled debug prints for a file
sudo sh -c 'echo "file pt_prefetch.c +p" > /sys/kernel/debug/dynamic_debug/control'
