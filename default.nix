{ mkDerivation, array, base, brick, bytestring, cereal, cereal-text
, containers, mtl, stdenv, text, transformers, unix
}:
mkDerivation {
  pname = "fima";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    array base brick bytestring cereal cereal-text containers mtl text
    transformers unix
  ];
  license = stdenv.lib.licenses.isc;
}
