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
                set -e

                # Clean old build
                rm -rf package collect-info_1.0_all.deb

                # Create directory structure
                mkdir -p package/usr/local/bin
                mkdir -p package/DEBIAN

                # Copy script
                cp collect_data.sh package/usr/local/bin/
                chmod 755 package/usr/local/bin/collect_data.sh

                # Create control file
                cat <<EOF > package/DEBIAN/control
Package: collect-info
Version: 1.0
Section: utils
Priority: optional
Architecture: all
Maintainer: Sanoj <sanojkumar715@email.com>
Depends: gum, sysstat
Description: A script that collects system information using gum UI.
EOF

                # Fix ownership to root:root
                chown -R root:root package

                echo "✅ Building DEB package..."
                dpkg-deb -Zgzip --build package collect-info_1.0_all.deb
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
