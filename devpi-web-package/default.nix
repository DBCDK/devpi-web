
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
, pyramid_chameleon
, readme_renderer
, defusedxml
}:

buildPythonPackage rec {
  pname = "devpi-web";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3CwoA9ud4Sx+qsPrbBas0J+qDqeLKsxI8vBA7ae0iLs=";
  };

  buildInputs = [
    glibcLocales
    devpi-server
  ];

  propagatedBuildInputs = [
    devpi-common
    defusedxml
    pkginfo
    pluggy
    beautifulsoup4
    py
    whoosh
    pyramid_chameleon
    pyramid
    setuptools
    readme_renderer
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "http://doc.devpi.net";
    description = "Addon for devpi-server, a searchable web-interface";
    license = licenses.mit;
    maintainers = [ "jozi" ];
  };
}
