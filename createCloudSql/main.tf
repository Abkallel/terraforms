variable "project_name" {
  type = "string"
}

provider "google-beta" {
  region = "europe-west1"
  zone   = "europe-west1-b"
}

resource "google_sql_database_instance" "master" {
  name             = "master-instance"
  database_version = "POSTGRES_11"
  region           = "europe-west1"
  depends_on       = ["google_service_networking_connection.private_vpc_connection"]
  project          = "${var.project_name}"

  connection {
    password = "wordpress"
    user     = "wordpress"
  }

  settings {
    tier      = "db-f1-micro"
    disk_type = "PD_SSD"
    disk_size = 10

    ip_configuration {
      ipv4_enabled    = false
      private_network = "${google_compute_network.private_network.self_link}"
    }
  }
}

resource "google_compute_network" "private_network" {
  name                    = "private-network"
  auto_create_subnetworks = true
  project                 = "${var.project_name}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = "${google_compute_network.private_network.self_link}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.private_network.self_link}"
  project       = "${var.project_name}"
}
