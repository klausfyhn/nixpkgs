{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, boost, SDL2, SDL2_image, SDL2_ttf, libpng
, glew, gettext, libsndfile, libvorbis, libogg, physfs, openal
, xmlstarlet, doxygen, python3, callPackage }:

let
  colobot-data = callPackage ./data.nix {};
in
stdenv.mkDerivation rec {
  pname = "colobot";
  # Maybe require an update to package colobot-data as well
  # in file data.nix next to this one
  version = "0.2.0-alpha";

  src = fetchFromGitHub {
    owner = "colobot";
    repo = pname;
    rev = "colobot-gold-${version}";
    sha256 = "sha256-Nu7NyicNIk5yza9sXfd4KbGdB65guVuGREd6rwRU3lU=";
  };

  patches = [
    # https://github.com/colobot/colobot/pull/1559
    # gcc13 fixes. remove on next update
    (fetchpatch {
      name = "gcc13-fixes.patch";
      url = "https://github.com/colobot/colobot/commit/d47e26586325ec11425cef5c95fc206dc103dbe2.patch";
      hash = "sha256-2DmLkyoyiZSW0yeZDSSWFjCEJos25jPHZQi1yuJGFko=";
      excludes = [
        "src/object/task/taskgoto.h"
      ];
    })
  ];

  nativeBuildInputs = [ cmake xmlstarlet doxygen python3 ];
  buildInputs = [ boost SDL2 SDL2_image SDL2_ttf libpng glew gettext libsndfile libvorbis libogg physfs openal ];

  enableParallelBuilding = false;

  # The binary ends in games directoy
  postInstall = ''
    mv $out/games $out/bin
    for contents in ${colobot-data}/share/games/colobot/*; do
      ln -s $contents $out/share/games/colobot
    done
  '';

  meta = with lib; {
    homepage = "https://colobot.info/";
    description = "Colobot: Gold Edition is a real-time strategy game, where you can program your bots";
    license = licenses.gpl3;
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.linux;
  };
}
