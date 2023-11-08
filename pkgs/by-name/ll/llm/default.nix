{python311Packages}: let
  inherit (python311Packages) toPythonApplication callPackage;
in
  toPythonApplication (callPackage ./../../../development/python-modules/llm {})
