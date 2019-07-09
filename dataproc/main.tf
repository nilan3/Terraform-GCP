resource "google_storage_bucket" "bucket" {
  name          = "${var.bucket_name}"
  location      = "EU"
  force_destroy = "true"
}

resource "google_dataproc_cluster" "poccluster" {
  name   = "${var.cluster_name}"
  region = "${var.region}"

  labels = {
    foo = "bar"
  }

  cluster_config {
    staging_bucket = "${var.bucket_name}"

    master_config {
      num_instances = "${var.master_num_instances}"
      machine_type  = "${var.master_machine_type}"

      disk_config {
        boot_disk_type    = "pd-ssd"
        boot_disk_size_gb = 30
      }
    }

    worker_config {
      num_instances = "${var.worker_num_instances}"
      machine_type  = "${var.worker_machine_type}"

      disk_config {
        boot_disk_size_gb = 30
        num_local_ssds    = 1
      }
    }

    preemptible_worker_config {
      num_instances = 0
    }

    # Override or set some custom properties
    software_config {
      image_version = "1.3.14-deb9"

      override_properties = {
        "dataproc:dataproc.allow.zero.workers" = "true"
      }
    }

    gce_cluster_config {
      network = "${var.network_name}"
      tags    = ["foo", "bar"]
    }

    # You can define multiple initialization_action blocks
    initialization_action {
      script      = "gs://dataproc-initialization-actions/stackdriver/stackdriver.sh"
      timeout_sec = 500
    }

    # initialization_action {
    #   script      = "gs://dataproc-initialization-actions/ganglia/ganglia.sh"
    #   timeout_sec = 500
    # }
    # Only needed if one master node is set up (non-HA mode)
    # initialization_action {
    #   script      = "gs://dataproc-initialization-actions/zookeeper/zookeeper.sh"
    #   timeout_sec = 5000
    # }

    initialization_action {
      script      = "gs://dataproc-initialization-actions/docker/docker.sh"
      timeout_sec = 500
    }

    initialization_action {
      script      = "gs://dataproc-initialization-actions/livy/livy.sh"
      timeout_sec = 500
    }
        initialization_action {
      script      = "gs://dataproc-initialization-actions/kafka/kafka.sh"
      timeout_sec = 500
    }
  }

  depends_on = ["google_storage_bucket.bucket"]

  timeouts {
    create = "30m"
    delete = "30m"
  }
}
