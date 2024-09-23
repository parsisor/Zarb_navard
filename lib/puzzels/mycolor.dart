class MyColor {
  static int gridBackground = 0xFFa2917d;
  static int gridColorTwoFour = 0xFFeee4da;
  static int fontColorTwoFour = 0xFF766c62;
  static int emptyGridBackground = 0xFFbfafa0;
  static int gridColorEightSixtyFourTwoFiftySix = 0xFFf5b27e;
  static int gridColorOneTwentyEightFiveOneTwo = 0xFFf77b5f;
  static int gridColorSixteenThirtyTwoOneZeroTwoFour = 0xFFecc402;
  static int gridColorWin = 0xFF60d992;
  static int transparentWhite = 0x80FFFFFF;

  static int getGridColor(int num) {
    if (num == 2 || num == 4) {
      return gridColorTwoFour;
    } else if (num == 8 || num == 64 || num == 256) {
      return gridColorEightSixtyFourTwoFiftySix;
    } else if (num == 16 || num == 32 || num == 1024) {
      return gridColorSixteenThirtyTwoOneZeroTwoFour;
    } else if (num == 128 || num == 512) {
      return gridColorOneTwentyEightFiveOneTwo;
    } else {
      return gridColorWin; 
    }
  }
}
