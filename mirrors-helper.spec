%define anolis_base_release 1


Name:           mirrors-helper
Version:        1.0.0
Release: 0.%{anolis_base_release}%{?dist}
Summary:        A tool for selecting mirrors
License:        GPL
BuildArch:      noarch

BuildRequires: python3
BuildRequires: python3-requests
BuildRequires: bc
BuildRequires: make


%description
sphinxcontrib-htmlhelp is a sphinx extension which renders HTML help files.

%prep
mkdir -p %{_topdir}/BUILD/mirrors-helper
cp %{_topdir}/SOURCES/* %{_topdir}/BUILD/mirrors-helper

%build
cd mirrors-helper
make package

%install
echo $PWD
mkdir -p %{buildroot}/%{_bindir}/
cp mirrors-helper/mirrors-helper %{buildroot}/%{_bindir}/

%files
%{_bindir}/%{name}

%changelog
* Wed Jul 14 2021 Zhongling He <zhongling.h@alibaba-inc.com> 1.0.0
Add mirror support for conda, cpan, cran, epel, go, npm, pip