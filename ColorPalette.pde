class ColorPalette {
  color[][] colors;
  color[] colors_dark;
  color[] colors_mid;
  color[] colors_bright;
  
  ColorPalette() {
    colors_dark = new color[]{
        color(89, 17, 23),
        color(11, 15, 38),
        color(15, 27, 64),
        color(23, 54, 115),
        color(166, 15, 15)

//      color(69, 41, 52),
//      color(43, 17, 28),
//      color(43, 42, 38),
//      color(30, 18, 22),
//      color(66, 33, 46)
    };
    
    colors_mid = new color[]{
      color(178, 165, 137),
      color(255, 184, 150),
      color(255, 249, 177),
      color(154, 178, 133),
      color(17, 146, 158)
    };
    
    colors_bright = new color[]{
      color(7, 105, 120),
      color(5, 148, 87),
      color(135, 39, 38),
      color(97, 13, 54),
    };
    
    colors = new color[][] {
      colors_dark,
      colors_mid,
      colors_bright,
    };
  }
}
