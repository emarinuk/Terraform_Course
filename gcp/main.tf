terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.37.0"
    }
  }
}

provider "google" {
  credentials = file("terraform-course-363310-b0e98b288c2b.json")
  project     = "terraform-course-363310"
  region      = "europe-southwest1"
  zone        = "europe-southwest1-b"
}

resource "google_compute_network" "my-vpc" {
  name = "my-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "my-subnet" {
  name          = "my-subnetwork"
  ip_cidr_range = var.var_uc1_private_subnet
  region        = "europe-southwest1"
  network       = google_compute_network.my-vpc.id

}

resource "google_compute_ha_vpn_gateway" "my-igw" {
  region   = "europe-southwest1"
  name     = "my-igw"
  network  = google_compute_network.my-vpc.id
}

