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
                sh 'SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt update && sudo -A apt install dpkg-dev rpm -y'
            }
        }

        stage('Build DEB Package') {
            steps {
                sh 'mkdir -p package/usr/local/bin'
                sh 'cp collect_data.sh package/usr/local/bin/'
                sh 'chmod +x package/usr/local/bin/collect_data.sh'

                sh 'mkdir -p package/DEBIAN'
                sh 'cp control package/DEBIAN/'
                sh 'echo "Building DEB package..."'
                sh 'dpkg-deb --build package collect-info_1.0_all.deb'
            }
        }


        stage('Archive Packages') {
            steps {
                archiveArtifacts artifacts: 'collect-info_1.0_all.deb', fingerprint: true
            }
        }
    }
}
