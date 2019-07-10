provider "google" {
  credentials = "${file("${var.credentials}")}"
  project = "${var.project_id}"
  region = "${var.region}"
  zone = "${var.region}-c"
}

module "network" {
  source = "./network"
  network_name = "${var.network_name}"
  subnet_cidr = "10.10.0.0/24"
  region = "${var.region}"
}

module "dataproc" {
  region = "${var.region}"
  source = "./dataproc"
  cluster_name = "poccluster"
  network_name = "${var.network_name}"
  bucket_name = "dataproc-poc-bucket"
  master_num_instances = 3
  master_machine_type = "n1-standard-2"
  worker_num_instances = 2
  worker_machine_type = "n1-standard-2"
}

module "spark" {
  region = "${var.region}"
  source = "./spark"
  cluster_name = "poccluster"
  bucket_name = "dataproc-poc-bucket"
}
