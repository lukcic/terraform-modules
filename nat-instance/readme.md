# Usage
```tf
module "nat-instance" {
  source = "../../../../modules/nat-instance"

  key_pair_name = var.key_pair_name
  nat_ami       = var.nat_ami
  vpc_id        = var.vpc_id
  vpc_cidr      = var.vpc_cidr
  subnet_id     = var.subnet_id
}
```

# Troubleshooting

```sh
cat /etc/sysctl.conf

```

should include `net.ipv4.ip_forward = 1`


```sh
sudo iptables -L -t nat

```