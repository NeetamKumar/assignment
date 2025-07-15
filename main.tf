terraform {
  backend "gcs"{
    bucket = "neetam_123"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "cts-neetama"
  zone = "us-central1-a"
}


resource "google_compute_instance" "instance1" {
  name = "instance1"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20250709"
    }    
  }
  network_interface {
    network = google_compute_network.network1.id
    subnetwork = google_compute_subnetwork.subnetwork1.id
  }
  lifecycle {
    create_before_destroy = true
    
  }
  allow_stopping_for_update = true
}

resource "google_compute_network" "network1" {
  name = "network1"
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "subnetwork1" {
  name = "subnetwork1"
  network = google_compute_network.network1.id
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_firewall" "firewall1" {
  name = "firewall1"
  network = google_compute_network.network1.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  allow {
    protocol = "tcp"
    ports = ["80"]
  
  }
}