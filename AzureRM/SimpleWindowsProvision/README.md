v0.12
-----
Almost. Wont copy a file as thinks it's ssh. Need to fix.
* dial tcp :22: connectex: The requested address is not valid in its context

v0.11
-----
Initial Working machine! Still needs an IP address reigstered on it and an NSG setup to point to RDP port of machine. Also, test puppet install etc...

v0.1
----
Testing with a windows image, got this error;

 azurerm_virtual_machine.demo: compute.VirtualMachinesClient#CreateOrUpdate: Failure responding to request: StatusCode=
00 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="InvalidParameter" Message="The value
f parameter linuxConfiguration is invalid."