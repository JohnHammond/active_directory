# 01 Installing the Domain Controller

1. Use `sconfig` to:
    - Change the hostname
    - Change the IP address to static
    - Change the DNS server to our own IP address

2. Install the Active Directory Windows Feature

```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```


```
Get-NetIPAddress
```

# Joining the Workstation to the domain



```
Add-Computer -Domainname xyz.com -Credential xyz\Administrator -Force -Restart
```
