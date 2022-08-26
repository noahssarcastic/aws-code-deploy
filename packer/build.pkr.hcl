build {
  name = "node-app"
  sources = [
    "source.amazon-ebs.al2"
  ]

  provisioner "shell" {
    inline = [
      "curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -",
      "sudo yum install -y nodejs"
    ]
  }

  provisioner "file" {
    source      = "${path.root}/../app"
    destination = "/tmp/app"
  }

  provisioner "file" {
    source      = "${path.root}/files/myapp.service"
    destination = "/tmp/myapp.service"
  }

  provisioner "shell" {
    inline = ["sudo mv /tmp/myapp.service /etc/systemd/system/myapp.service"]
  }

  provisioner "shell" {
    script = "${path.root}/files/install_code_deploy_agent.sh"
  }
}
