#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl wget gnupg2 software-properties-common apt-transport-https ca-certificates python3 python3-pip

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

apt-get update
apt-get install -y openjdk-17-jdk jenkins docker-ce docker-ce-cli containerd.io nodejs git unzip awscli

systemctl enable jenkins docker
systemctl start docker jenkins

usermod -aG docker jenkins ubuntu

mkdir -p /usr/local/bin

curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash -s -- -b /usr/local/bin
chmod +x /usr/local/bin/tfsec

curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
chmod +x /usr/local/bin/trivy

pip3 install checkov

sleep 30

echo "admin123" > /var/lib/jenkins/secrets/initialAdminPassword
chown jenkins:jenkins /var/lib/jenkins/secrets/initialAdminPassword

mkdir -p /var/lib/jenkins/init.groovy.d
cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy << 'GROOVY'
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin123")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)
instance.save()
GROOVY

chown jenkins:jenkins /var/lib/jenkins/init.groovy.d/basic-security.groovy
systemctl restart jenkins
