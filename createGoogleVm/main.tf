variable "project_name" {}
variable "region_name" {}
variable "zone_name" {}

provider "google" {
  project = "${var.project_name}"
  region  = "${var.region_name}"
  zone    = "${var.zone_name}"
}


resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "${google_compute_network.vpc_network.self_link}"
  }
}


resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}