# Variables
$location = "eastus"
$vnetName = "vnet1"
$addressPrefix = "10.0.0.0/16"
$subnetName = "subnet1"
$subnetPrefix = "10.0.0.0/24"

$vm1Name = "myVM"
$vm1Username = "ssjuser"
$vm1Password = "Password123!"  # Ensure you set a strong password

$vm2Name = "myVM1"
$vm2Username = "azureuser"
$vm2Password = "Password123!"  # Ensure you set a strong password

# Create a resource group
az group create --name MyResourceGroup --location $location

# Create a virtual network with a subnet
az network vnet create --name $vnetName --resource-group MyResourceGroup --location $location --address-prefix $addressPrefix --subnet-name $subnetName --s
# Create a public IP address for VM1
az network public-ip create --resource-group MyResourceGroup --name PublicIPVM1 --allocation-method Static

# Create a network interface for VM1
az network nic create --resource-group MyResourceGroup --name NICVM1 --vnet-name $vnetName --subnet $subnetName --public-ip-address PublicIPVM1

# Create VM1
az vm create --resource-group MyResourceGroup --name $vm1Name --location $location --nics NICVM1 --image Win2019Datacenter --admin-username $vm1Username --admin-password $vm1Password --size Standard_B1s

# Create a network security group and rule for VM2
az network nsg create --resource-group MyResourceGroup --name NSGVM2
az network nsg rule create --resource-group MyResourceGroup --nsg-name NSGVM2 --name Allow-RDP --protocol Tcp --direction Inbound --priority 1000 --source-address-prefix '*' --source-port-range '*' --destination-address-prefix '*' --destination-port-range 3389 --access Allow

# Create a public IP address for VM2
az network public-ip create --resource-group MyResourceGroup --name PublicIPVM2 --allocation-method Static

# Create a network interface for VM2
az network nic create --resource-group MyResourceGroup --name NICVM2 --vnet-name $vnetName --subnet $subnetName --public-ip-address PublicIPVM2 --network-security-group NSGVM2

# Create VM2
az vm create --resource-group MyResourceGroup --name $vm2Name --location $location --nics NICVM2 --image Win2019Datacenter --admin-username $vm2Username --admin-password $vm2Password --size Standard_B1s

# Output public IPs of the VMs
Write-Output "VM1 Public IP:"
az network public-ip show --resource-group MyResourceGroup --name PublicIPVM1 --query "ipAddress" --output tsv