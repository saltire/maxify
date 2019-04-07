color skyColor;

int minRays = 10;
int maxRays = 30;
int rayCount;
float rayOffset;
float rayLength = 1200;
color rayColor;

PVector sun;
float minSunRadius = 10;
float maxSunRadius = 150;
float sunRadius;
color sunColor;

int minStars = 10;
int maxStars = 50;
int starCount;
int minStarRadius = 5;
int maxStarRadius = 50;
PVector[] starPositions;
float[] starRadii;
float[] starOffsets;
color starColor;

float minCloudHeight = 50;
float maxCloudHeight = 200;
float maxCloudAngle = .125;
float minCloudRadius = 10;
float maxCloudRadius = 100;
PVector[] cloudPositions;
float[] cloudRadii;
PVector[] cloudCorners;
color cloudColor;

float up = -.25 * TAU;

void setup() {
  size(750, 750);
  ellipseMode(RADIUS);
  strokeJoin(ROUND);

  initialize();
}

void mouseClicked() {
  initialize();
}

void initialize() {
  skyColor = #2090d6;
  rayColor = #f24905;
  sunColor = #eb9500;
  starColor = #eade03;
  cloudColor = #f480b7;

  rayCount = floor(random(minRays, maxRays + 1) / 2) * 2;
  rayOffset = random(0, 1);

  sun = new PVector(random(0, width), random(0, height));
  sunRadius = random(minSunRadius, maxSunRadius);

  starCount = floor(random(minStars, maxStars + 1));
  starPositions = new PVector[starCount];
  starRadii = new float[starCount];
  starOffsets = new float[starCount];
  for (int i = 0; i < starCount; i++) {
    starRadii[i] = random(minStarRadius, maxStarRadius);
    starOffsets[i] = random(0, 1);
    starPositions[i] = placeStar(i);
  }

  placeClouds();
}

void draw() {
  background(skyColor);
  stroke(0);
  strokeWeight(3);

  fill(rayColor);
  for (float i = 0; i < rayCount; i += 2) {
    PVector point1 = pointOnCircle(sun, (i / rayCount + rayOffset) * TAU, rayLength);
    PVector point2 = pointOnCircle(sun, ((i + 1) / rayCount + rayOffset) * TAU, rayLength);
    triangle(point1, sun, point2);
  }

  fill(sunColor);
  circle(sun, sunRadius);

  fill(starColor);
  for (int i = 0; i < starCount; i++) {
    star(starPositions[i], starRadii[i], starOffsets[i]);
  }

  clouds();
}

void placeClouds() {
  cloudPositions = new PVector[1];
  cloudRadii = new float[1];
  cloudCorners = new PVector[1];

  int i = 0;
  cloudPositions[0] = new PVector(-20, height - random(minCloudHeight, maxCloudHeight));
  cloudRadii[0] = random(minCloudRadius, maxCloudRadius);
  cloudCorners[0] = pointOnCircle(cloudPositions[0], up, cloudRadii[0]);

  while (cloudPositions[i].x < width) {
    float angle = random(-maxCloudAngle, maxCloudAngle) * TAU;
    float radius = random(minCloudRadius, maxCloudRadius);
    PVector origin = pointOnCircle(cloudPositions[i], angle, cloudRadii[i] + radius);
    cloudPositions = (PVector[])append(cloudPositions, origin);
    cloudRadii = append(cloudRadii, radius);
    cloudCorners = (PVector[])append(cloudCorners,
      pointOnCircle(origin, angle - .5 * TAU, radius));
    i += 1;
  }

  cloudCorners = (PVector[])append(cloudCorners,
    pointOnCircle(cloudPositions[i], up, cloudRadii[i]));
}

PVector placeStar(int i) {
  PVector star;
  boolean sunClear;
  boolean starsClear;
  int tries = 0;
  do {
    star = new PVector(random(0, width), random(0, height));

    sunClear = dist(star, sun) > (sunRadius + starRadii[i]);

    starsClear = true;
    if (sunClear) {
      for (int j = 0; j < i; j++) {
        if (dist(star, starPositions[j]) <= (starRadii[i] + starRadii[j])) {
          starsClear = false;
          break;
        }
      }
    }

    tries += 1;
  }
  while ((!sunClear || !starsClear) && tries < 100);

  return star;
}

void star(PVector origin, float radius, float offset) {
  beginShape();
  for (float i = 0; i < 5; i++) {
    float oa = (i / 5 + offset) * TAU;
    float ia = ((i + .5) / 5 + offset) * TAU;
    vertex(pointOnCircle(origin, oa, radius));
    vertex(pointOnCircle(origin, ia, radius / 2));
  }
  endShape(CLOSE);
}

PVector pointOnCircle(PVector origin, float angle, float radius) {
  return new PVector(origin.x + cos(angle) * radius, origin.y + sin(angle) * radius);
}

void clouds() {
  fill(cloudColor);

  push();
    stroke(cloudColor);
    beginShape();
      int i;
      for (i = 0; i < cloudPositions.length; i++) {
        vertex(cloudCorners[i]);
        vertex(cloudPositions[i]);
      }
      vertex(cloudPositions[i - 1].x, height + 10);
      vertex(cloudPositions[0].x, height + 10);
    endShape();
  pop();

  for (i = 0; i < cloudPositions.length; i++) {
    float left = i == 0 ? up : atan2(
      cloudPositions[i - 1].y - cloudPositions[i].y,
      cloudPositions[i - 1].x - cloudPositions[i].x);
    float right = i == cloudPositions.length - 1 ? up : atan2(
      cloudPositions[i + 1].y - cloudPositions[i].y,
      cloudPositions[i + 1].x - cloudPositions[i].x);
    if (right < left) {
      right += TAU;
    }
    arc(cloudPositions[i].x, cloudPositions[i].y, cloudRadii[i], cloudRadii[i], left, right);
  }
}
