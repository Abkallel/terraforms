This example allow to provision a google vm instance with auto network using a terraform script. 
We assume that you have already a gcp project. If you launch it locally, you will need to install terraform. 
Terraform bin is already installed on Cloud Shell machine.

Just tape this command to create the vm 
terraform apply -var project_name="<GOOGLE_PROJECT_ID>" -var region_name="<GOOGLE_REGION>" -var  zone_name="<GOOGLE_ZONE>" 