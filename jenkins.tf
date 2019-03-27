
resource "docker_volume" "jenkins_data" {
  name = "jenkins_data"
  driver = "local-persist"
  driver_opts = {
      "mountpoint" = "${var.jenkins_data_mount}"
  }
}
resource "docker_service" "jenkins" {
    name = "jenkins-service"

    task_spec {
        container_spec {
            image = "jenkins/jenkins:lts"

            labels {
                traefik.frontend.rule = "Host:${var.url}"
                traefik.port = 8080
                traefik.docker.network = "${var.traefik_network}"
            }

         

            mounts = [
                {
                    source      = "${docker_volume.jenkins_data.name}"
                    target      = "/var/jenkins_home"   
                    type        = "volume"
                    read_only   = false
                },
                
            ]
        }
        networks     = ["${var.networks}"]
    }
}