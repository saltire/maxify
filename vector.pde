void circle(PVector p, float radius) {
  circle(p.x, p.y, radius);
}

float dist(PVector p1, PVector p2) {
  return dist(p1.x, p1.y, p2.x, p2.y);
}

void line(PVector p1, PVector p2) {
  line(p1.x, p1.y, p2.x, p2.y);
}

void triangle(PVector p1, PVector p2, PVector p3) {
  triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
}

void vertex(PVector p) {
  vertex(p.x, p.y);
}
