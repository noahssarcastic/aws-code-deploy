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
}
