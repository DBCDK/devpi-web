
{ lib
, buildPythonPackage
, devpi-common
, fetchPypi
, glibcLocales
, pkginfo
, pluggy
, py
, setuptools
, beautifulsoup4
, pyramid
, whoosh
, devpi-server
, pyramid-chameleon
, readme-renderer
, defusedxml
, setuptools-changelog-shortener
}:

buildPythonPackage rec {
  pname = "devpi_web";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zeET0D/yGVjFTlH+sxVajfJeilZ4UDkOk5vUqya+btw=";
  };

  buildInputs = [
    glibcLocales
    devpi-server
  ];

  buildSystem = [ "setuptools" ];

  pyproject = true;

  propagatedBuildInputs = [
    devpi-common
    defusedxml
    pkginfo
    pluggy
    beautifulsoup4
    py
    whoosh
    pyramid-chameleon
    setuptools-changelog-shortener
    pyramid
    setuptools
    readme-renderer
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "http://doc.devpi.net";
    description = "Addon for devpi-server, a searchable web-interface";
    license = licenses.mit;
    maintainers = [ "jozi" ];
  };
}
