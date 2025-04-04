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
                sh '''
                cat <<EOF > package/DEBIAN/control
                Package: collect-info
                Version: 1.0
                Section: utils
                Priority: optional
                Architecture: all
                Maintainer: sanoj sanojkumar715@email.com
                Description: A script that collects system information using gum UI.
                EOF
                '''

                sh 'dpkg-deb --build package collect-info_1.0_all.deb'
            }
        }

        stage('Build RPM Package') {
            steps {
                sh 'echo "Starting RPM build process..."'
                sh 'which rpmbuild || echo "rpmbuild not found!"'

                # Create necessary RPM directories
                sh 'mkdir -p rpm_package/{BUILD,RPMS/noarch,SOURCES,SPECS,SRPMS,tmp}'
                sh 'mkdir -p rpm_package/tmp/usr/local/bin'

                # Copy the script
                sh 'cp collect_data.sh rpm_package/SOURCES/'
                sh 'chmod +x rpm_package/SOURCES/collect_data.sh'

                # Create SPEC file
                sh '''
                cat <<EOF > rpm_package/SPECS/collect-info.spec
                Name: collect-info
                Version: 1.0
                Release: 1%{?dist}
                Summary: A script that collects system information using gum UI.
                License: GPL
                BuildArch: noarch

                %description
                A script that collects system information using gum UI.

                %prep
                mkdir -p %{_tmppath}/usr/local/bin
                cp %{_sourcedir}/collect_data.sh %{_tmppath}/usr/local/bin/
                chmod +x %{_tmppath}/usr/local/bin/collect_data.sh

                %install
                mkdir -p %{buildroot}/usr/local/bin
                cp %{_tmppath}/usr/local/bin/collect_data.sh %{buildroot}/usr/local/bin/
                chmod +x %{buildroot}/usr/local/bin/collect_data.sh

                %files
                /usr/local/bin/collect_data.sh

                %changelog
                * Fri Apr 5 2024 Sanoj <sanojkumar715@email.com> - 1.0-1
                - Initial RPM release
                EOF
                '''

                # Build RPM package
                sh 'echo "Running rpmbuild..."'
                sh 'rpmbuild --define "_topdir $(pwd)/rpm_package" -bb rpm_package/SPECS/collect-info.spec'
            }
        }

        stage('Archive Packages') {
            steps {
                archiveArtifacts artifacts: 'collect-info_1.0_all.deb, rpm_package/RPMS/noarch/collect-info-1.0-1.noarch.rpm', fingerprint: true
            }
        }
    }
}
