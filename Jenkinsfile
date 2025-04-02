pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sanoj-sudo/collect.git'
            }
        }
        
        stage('Setup Environment') {
            steps {
                sh 'SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt update && sudo -A apt install dpkg-dev -y'
            }
        }


        stage('Build DEB Package') {
            steps {
                sh 'mkdir -p package/usr/local/bin'
                sh 'cp collect_info.sh package/usr/local/bin/'
                sh 'chmod +x package/usr/local/bin/collect_info.sh'
                sh 'mkdir -p package/DEBIAN'
                sh 'echo "Package: collect-info\nVersion: 1.0\nSection: utils\nPriority: optional\nArchitecture: all\nMaintainer: sanoj sanojkumar715@email.com\nDescription: A script that collects system information using gum UI." > package/DEBIAN/control'
                sh 'dpkg-deb --build package collect-info_1.0_all.deb'
            }
        }

        stage('Archive Package') {
            steps {
                archiveArtifacts artifacts: 'collect-info_1.0_all.deb', fingerprint: true
            }
        }
    }
}
