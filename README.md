Terrform configuration for gophsih/postfix stmp server on multiple providers
FILE cloud_init.cfg

1. Libvirt - localhost
2. AWS
3. Azure
4. Civo

Aim is to spin up bare servers and use cloud_init.cfg for identical config across all providers.

## Instructions for localhost deployment of gohpish/postfix

1. Set instance and resource variables in `variables.tf` ESPECIALLY THE CLOUD INIT FILE cloud_init.cfg in main.tf line 10
2. Run the following:

```
terraform init
terraform plan
terraform apply
```

## in localhost to get IPs (may take up to 30 seconds before IPs come up):

virsh net-dhcp-leases ${VM_HOSTNAME}\_network

## ssh into VMs

ssh ${VM_USER}@ip_address

## check postfix installed (plus other services)

service --status-all

## to get cloud-init build log (check for error messages in build)

sudo tail cloud-init.log

## to get gophish initial password when running cloud_init.cfg

cd /var/log
sudo tail -n 200 cloud-init-output.log

## to check postfix mail log

cd /var/log
sudo tail mail.log

## access gophish on libvirt(localhost)

get ip address (e.g. 10.10.10.179) and call 'https://<ip address>:3333' in browser

## to send test email with gmail as the final relay from gophish, setup the following in cloud_init.cfg (currently at line 30), ensure the gmail account you use has less_secure apps enabled. The format is user:password for gmail.

```

write_files:

- path: /etc/postfix/sasl_passwd
  content: |
  [smtp.gmail.com]:587 gmail_username:gmail_password
  owner: root:root
  permissions: 0400

```

In the sending profile at '/sending_profiles' fill in:

Name <profile name, can be anything>
From <gmail account>
Host: localhost: 25

You can leave the other fields blank. Send a test email to your own email address, you should receive an email with subject 'Default Email from Gophish'.
This demonstrates that you are sending an email through postfix (localhost:25) to smtp.gmail.com, and then on to your mailbox.

Issues can be tracked in the logs referenced above.

## exit then run

```
terraform destroy
```

## Resources

http://flurdy.com/docs/postfix/
https://www.exratione.com/2019/02/a-mailserver-on-ubuntu-18-04-postfix-dovecot-mysql/
https://www.linuxbabe.com/mail-server/setup-basic-postfix-mail-sever-ubuntu

## This might be an alternative for server 2:

https://www.linuxbabe.com/mail-server/ubuntu-18-04-iredmail-email-server
