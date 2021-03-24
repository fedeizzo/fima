{ mkDerivation, array, base, brick, bytestring, cereal, cereal-text
, containers, hspec, mtl, QuickCheck, quickcheck-text, stdenv, text
, time, transformers, unix, vty
}:
mkDerivation {
  pname = "fima";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    array base brick bytestring cereal cereal-text containers mtl text
    time transformers unix vty
  ];
  executableHaskellDepends = [
    array base brick bytestring cereal cereal-text containers mtl text
    time transformers unix vty
  ];
  testHaskellDepends = [
    array base brick bytestring cereal cereal-text containers hspec mtl
    QuickCheck quickcheck-text text time transformers unix vty
  ];
  description = "Personal finance tracking service";
  license = stdenv.lib.licenses.isc;
}
