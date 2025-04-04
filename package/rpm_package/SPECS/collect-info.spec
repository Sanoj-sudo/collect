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