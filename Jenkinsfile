pipeline {
    agent any

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'project47', url: 'https://github.com/Sanoj-sudo/collect.git'
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

        stage('Build RPM Package') {
            steps {
                sh 'echo "Starting RPM build process..."'
                sh 'which rpmbuild || echo "rpmbuild not found!"'

                // Create necessary RPM directories
                sh 'mkdir -p rpm_build/{BUILD,RPMS,SOURCES,SPECS,SRPMS}'
                sh 'mkdir -p rpm_build/usr/local/bin'

                // Copy the script
                sh 'cp package/rpm_package/script/collect_data.sh rpm_build/SOURCES/'
                sh 'chmod +x rpm_build/SOURCES/collect_data.sh'

                // Create SPEC file
                sh 'cp package/rpm_package/SPECS/collect-info.spec rpm_build/SPECS/collect-info.spec'

                // Build RPM package
                sh 'echo "Running rpmbuild..."'
                sh 'rpmbuild --define "_topdir $(pwd)/rpm_build" -bb rpm_build/SPECS/collect-info.spec'
            }
        }

        stage('Archive Packages') {
            steps {
                archiveArtifacts artifacts: 'collect-info_1.0_all.deb, rpm_build/RPMS/noarch/*.rpm', fingerprint: true
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
