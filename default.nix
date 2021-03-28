{ mkDerivation, array, base, brick, bytestring, cereal, cereal-text
, containers, hspec, microlens, microlens-th, mtl, QuickCheck
, quickcheck-text, stdenv, text, time, transformers, unix, vector
, vty
}:
mkDerivation {
  pname = "fima";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    array base brick bytestring cereal cereal-text containers microlens
    microlens-th mtl text time transformers unix vector vty
  ];
  executableHaskellDepends = [
    array base brick bytestring cereal cereal-text containers microlens
    microlens-th mtl text time transformers unix vector vty
  ];
  testHaskellDepends = [
    array base brick bytestring cereal cereal-text containers hspec
    microlens microlens-th mtl QuickCheck quickcheck-text text time
    transformers unix vector vty
  ];
  description = "Personal finance tracking service";
  license = stdenv.lib.licenses.isc;
}
