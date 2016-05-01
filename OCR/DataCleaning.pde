/***************** This Stuff Actually Works *********************/

// Gets rid of everything that we don't want, plus some stuff that we do want (see dilate())
void erode(int [] letter) {
  int w = 50;
  int h = 50;
  int [] newLetter = new int [letter.length];
  for (int i = 1; i < w - 1; i++) {
    for (int j = 1; j < h - 1; j++) {
      int c11 = letter[index(i -1, j - 1)];
      int c12 = letter[index(i + 1, j - 1)];
      int c21 = letter[index(i - 1, j + 1)];
      int c22 = letter[index(i + 1, j + 1)];
      newLetter[index(i, j)] = min(c11, min(c12, min(c21, c22)));
    }
  }
  letter = newLetter;
}

// This keeps the stuff that we don't want gone but also brings back some details that
// we do want.
void dilate(int [] letter) {
  int w = 50;
  int h = 50;
  int [] newLetter = new int [letter.length];
  for (int i = 1; i < w - 1; i++) {
    for (int j = 1; j < h - 1; j++) {
      int c11 = letter[index(i -1, j - 1)];
      int c12 = letter[index(i + 1, j - 1)];
      int c21 = letter[index(i - 1, j + 1)];
      int c22 = letter[index(i + 1, j + 1)];
      newLetter[index(i, j)] = max(c11, max(c12, max(c21, c22)));
    }
  }
  letter = newLetter;
}