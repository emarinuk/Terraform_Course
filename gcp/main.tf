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
}
