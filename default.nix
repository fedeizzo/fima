{ mkDerivation, base, bytestring, cereal, stdenv }:
mkDerivation {
  pname = "fima";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring cereal ];
  license = stdenv.lib.licenses.isc;
}
