# Variables
$location = "eastus"
$vnetName = "vnet1"
$addressPrefix = "10.0.0.0/16"
$subnetName = "subnet1"
$subnetPrefix = "10.0.0.0/24"

$vm1Name = "myVM"
$vm1Username = "ssjuser"
$vm1Password = "Password123!"  # Ensure you set a strong password

# Create a resource group
az group create --name MyResourceGroup --location $location

# Create a virtual network with a subnet
az network vnet create --name $vnetName --resource-group MyResourceGroup --location $location --address-prefix $addressPrefix --subnet-name $subnetName --subnet-prefix $subnetPrefix

# Create a public IP address for VM1
az network public-ip create --resource-group MyResourceGroup --name PublicIPVM1 --allocation-method Static

# Create a network interface for VM1
az network nic create --resource-group MyResourceGroup --name NICVM1 --vnet-name $vnetName --subnet $subnetName --public-ip-address PublicIPVM1

# Create VM1
az vm create --resource-group MyResourceGroup --name $vm1Name --location $location --nics NICVM1 --image Win2019Datacenter --admin-username $vm1Username --admin-password $vm1Password --size Standard_B1s


# Output public IPs of the VMs
Write-Output "VM1 Public IP:"
az network public-ip show --resource-group MyResourceGroup --name PublicIPVM1 --query "ipAddress" --output tsv