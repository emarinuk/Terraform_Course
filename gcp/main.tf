terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.37.0"
    }
  }
}


provider "google" {
  credentials = file("terraform-course-363310-ed53e73e81e1.json")

  project = "terraform-course-363310"
  region  = "europe-southwest1"
  zone    = "europe-southwest1-b"
}

