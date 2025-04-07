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
                sh '''
                mkdir -p package/usr/local/bin
                cp collect_data.sh package/usr/local/bin/
                chmod +x package/usr/local/bin/collect_data.sh

                mkdir -p package/DEBIAN
                cp control package/DEBIAN/

                echo "Building DEB package..."
                dpkg-deb --build package collect-info_1.0_all.deb
                '''
            }
        }

        stage('Archive DEB') {
            steps {
                archiveArtifacts artifacts: 'collect-info_1.0_all.deb', fingerprint: true
            }
        }
    }
}
