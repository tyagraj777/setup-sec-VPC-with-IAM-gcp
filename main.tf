provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc" {
  name = "secure-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc.id
  region        = var.region
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  network       = google_compute_network.vpc.id
  region        = var.region
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "deny_all" {
  name    = "deny-all-ingress"
  network = google_compute_network.vpc.name

  direction = "INGRESS"
  priority  = 1000

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_project_iam_binding" "vpc_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"

echo " update the project compute service account name below..!!!"  
  members = [
    "serviceAccount:xxxxxxxxxx-compute@developer.gserviceaccount.com"
  ]
}

# Outputs
output "vpc_name" {
  description = "Name of the VPC"
  value       = google_compute_network.vpc.name
}

output "public_subnet_self_link" {
  description = "Self-link of the public subnet"
  value       = google_compute_subnetwork.public_subnet.self_link
}

output "private_subnet_self_link" {
  description = "Self-link of the private subnet"
  value       = google_compute_subnetwork.private_subnet.self_link
}

output "firewall_allow_ssh_name" {
  description = "Name of the SSH firewall rule"
  value       = google_compute_firewall.allow_ssh.name
}

output "firewall_deny_all_name" {
  description = "Name of the deny-all firewall rule"
  value       = google_compute_firewall.deny_all.name
}
