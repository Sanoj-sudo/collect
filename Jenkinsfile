pipeline {
    agent any

    environment {
        PACKAGE_NAME = "collect-info"
        VERSION = "1.0"
        ARCH = "all"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sanoj-sudo/collect.git'
            }
        }

        stage('Setup Environment') {
            steps {
                sh 'SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt update'
                sh 'SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt install dpkg-dev fakeroot curl gnupg -y'
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

                # Copy script and rename it for usage
                cp collect_data.sh package/usr/local/bin/collect-info
                chmod 755 package/usr/local/bin/collect-info

                # Create control file
                cat <<EOF > package/DEBIAN/control
Package: collect-info
Version: 1.0
Section: utils
Priority: optional
Architecture: all
Maintainer: Sanoj <sanojkumar715@email.com>
Description: A script that collects system information using gum UI.
EOF

                # Create postinst script to install dependencies
                cat <<'EOF' > package/DEBIAN/postinst
#!/bin/bash

# Install gum if missing
if ! command -v gum &> /dev/null; then
    echo "[INFO] Installing gum..."
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" > /etc/apt/sources.list.d/charm.list
    apt update
    apt install gum -y
fi

# Install sysstat if mpstat is missing
if ! command -v mpstat &> /dev/null; then
    echo "[INFO] Installing sysstat..."
    apt update
    apt install sysstat -y
fi

exit 0
EOF

                chmod +x package/DEBIAN/postinst

                echo "✅ Building DEB package..."
                fakeroot dpkg-deb -Zgzip --build package collect-info_1.0_all.deb
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
