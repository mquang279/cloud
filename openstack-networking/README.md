# 1. Basic

# 2. Advance
<div align="center">
  <img src="img/image.png" alt="alt text" width="550"/>
</div>

> Vì muốn thử triển khai với *Terraform* và *Ansible* nên em sẽ sử dụng 2 Tool này để thực hiện bài lab.
> 
> Source code: https://github.com/mquang279/cloud/tree/main/openstack-networking/advance

Kiến trúc triển khai như hình trên, với cấu hình của từng VM là:
- **VM1:** 20GB Disk, 4GB Ram, Ubuntu Server 22.04
- **VM2:** 20GB Disk, 4GB Ram, Ubuntu Server 22.04
- **VM3:** 10GB Disk, 2GB Ram, Ubuntu Server 22.04

Đầu tiên, sử dụng Terraform và libvirt để tạo VM1 & VM2:
![alt text](img/image-2.png)
Tạo SSH key pair trên máy bare-mental và copy public key vào 2 VM vừa tạo:
![alt text](img/image-3.png)
Tiếp theo, chạy Ansible-playbook để tạo ra VM3 bên trong VM2 với cấu hình của VM3 là: 10GB Disk, 2GB Ram, Ubuntu Server 22.04
![alt text](img/image-4.png)
Chạy Ansible-playbook để tạo default storage pool bên trong VM2
![alt text](img/image-5.png)
Kiểm tra IP của VM3, danh sách VM trong VM1 và danh sách VM trong VM2
![alt text](img/image-6.png)
<div align="center">
  <img src="img/image-7.png" alt="alt text" width="350"/>
</div>

<div align="center">
  <img src="img/image-8.png" alt="alt text" width="350"/>
</div>

SSH vào VM1 và thực hiện live migrate VM3 từ VM1 sang VM2:
<div align="center">
  <img src="img/image-9.png" alt="alt text" width="600"/>
</div>

<div align="center">
  <img src="img/image-10.png" alt="alt text" width="350"/>
</div>

**Tham khảo:**
- https://github.com/ArmanTaheriGhaleTaki/terraform-libvirt-sample
- https://oneuptime.com/blog/post/2026-03-04-manage-virtual-machine-storage-pools-volumes-rhel/view#creating-a-directory-based-storage-pool
- https://phip1611.de/blog/live-migration-of-qemu-kvm-vms-with-libvirt-command-cheat-sheet-and-tips/
- ChatGPT
# 3. Expert
