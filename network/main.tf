resource "google_compute_network" "vpc" {
 name = "${var.network_name}-vpc"
 auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
 name = "${var.network_name}-subnet"
 ip_cidr_range = "${var.subnet_cidr}"
 network = "${var.network_name}-vpc"
 depends_on = ["google_compute_network.vpc"]
 region = "${var.region}"
}

resource "google_compute_firewall" "firewall" {
  name = "${var.network_name}-firewall"
  network = "${google_compute_network.vpc.name}"
  // Allow ping
  allow {
    protocol = "icmp"
  }
  // Allow incoming SSH connections
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  // Allow incoming HTTP & HTTPS traffic
  allow {
    protocol = "tcp"
    ports = ["80", "443"]
  }
  // Allow incoming connections to typespeed
  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
}
