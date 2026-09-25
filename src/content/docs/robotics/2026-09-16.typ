#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Forward and inverse kinematics, reference frames, rotation matrices and their properties: orthogonality, inverse and transpose, and the SO(3) orthogonal group.",
  lang: "en",
  title: "Forward and inverse kinematics, frames, rotations",
))

= Forward vs inverse kinematics

Forward kinematics is used to establish the position of the effector based on
the configuration of the robot. The individual angles of the arms are parameters
that we know and can control.

Inverse kinematics is used in the case where we need to move the robot's arm
from a starting position that we know, to a final one, for which we need to
calculate the new angle values.

In case $phi$ is not known, inverse kinematics returns 2 possible arm
configurations to reach the same point:

$
  q_2 = plus.minus arccos((p_x^2 + p_y^2 - l_1^2 - l_2^2) / (2 l_1 l_2)) \
  q_1 = op("atan2")(p_y, p_x) - op("atan2")(l_2 sin(q_2), l_1 + l_2 cos(q_2))
$

Generally speaking, given a manipulator with $n$ joints, a vector of joint
variables $bold(q)$, and the position $bold(p)$ of the effector:

- Forward kinematics is about finding $bold(p) = f(bold(q))$;
- Inverse kinematics is about finding $bold(q) = f^(-1)(bold(p))$

= Reference frames

From now on, we will use the following convention: given reference frame $0$,
the point $bold(p)^0$'s coordinates will be relative to that reference frame
(the superscript denotes the frame).

The same point $bold(p)$ can of course be associated with different coordinates
relative to another reference frame, and in that case it will be denoted
$bold(p)^1$.

A frame is uniquely identified by the position of its origin and by the
coordinates of the three unit vectors.

#starlight.note([
  It is common to change reference frames, for example to account for the
  different positions of different sensors.
])

== Rotation matrices

Let's take 2 reference frames, with the same origin and one rotated by an angle
$alpha$ with respect to the other.

#starlight.img(
  "images/2-frames-rotated-alpha.png",
  alt: "2 frames separated by angle alpha",
)

We will eventually find that:

$
  p'_x = p_x cos(alpha) + p_y sin(alpha) \
  p'_y = -p_x sin(alpha) + p_y cos(alpha) \
$

which means:

$
  bold(p)' = mat(delim: "[", cos(alpha), sin(alpha); -sin(alpha), cos(alpha)) times bold(p)
$

This matrix, which is orthogonal (the columns have unit norm and are mutually
orthogonal), is easily invertible, since the transpose is equal to the inverse.

== Generalization of rotation matrices

#starlight.img(
  "images/2-frames-rotated-moved.png",
  alt: "Rigid body in another reference frame, with different origins",
)

Let's consider a point belonging to the body. Let $bold(p)$ be the vector
joining the origin $bold(0)$ with the point in a reference frame with basis
${bold(x), bold(y), bold(z)}$, and $bold(p)'$ the vector joining $bold(0)'$ with
the point on a reference frame with basis ${bold(x)', bold(y)', bold(z)'}$. Let
$bold(0) bold(0)'$ be the vector joining the two origins.

We have:

$
  p_x = bold(p) dot bold(x) = bold(p)' dot bold(x) + bold(0) bold(0)'_x = p'_x (bold(x)' dot bold(x)) + p'_y (bold(y)' dot bold(x)) + p'_z (bold(z)' dot bold(x)) + bold(0) bold(0)'_x \
  p_y = bold(p) dot bold(y) = bold(p)' dot bold(y) + bold(0) bold(0)'_y = p'_x (bold(x)' dot bold(y)) + p'_y (bold(y)' dot bold(y)) + p'_z (bold(z)' dot bold(y)) + bold(0) bold(0)'_y \
  p_z = bold(p) dot bold(z) = bold(p)' dot bold(z) + bold(0) bold(0)'_z = p'_x (bold(x)' dot bold(z)) + p'_y (bold(y)' dot bold(z)) + p'_z (bold(z)' dot bold(z)) + bold(0) bold(0)'_z
$

Which in more compact form is written:

$
  mat(delim: "[", p_x; p_y; p_z) = bold(R) mat(delim: "[", p'_x; p'_y; p'_z) + mat(delim: "[", bold(0) bold(0)'_x; bold(0) bold(0)'_y; bold(0) bold(0)'_z)
$

where:

$
  bold(R) = mat(
    delim: "[",
    x'_x, y'_x, z'_x;
    x'_y, y'_y, z'_y;
    x'_z, y'_z, z'_z
  ) = mat(
    delim: "[",
    bold(x)' dot bold(x), bold(y)' dot bold(x), bold(z)' dot bold(x);
    bold(x)' dot bold(y), bold(y)' dot bold(y), bold(z)' dot bold(y);
    bold(x)' dot bold(z), bold(y)' dot bold(z), bold(z)' dot bold(z)
  )
$

If we compute $bold(R) bold(R)^T$ we obtain $I$, which means that
$bold(R)^T = bold(R)^(-1)$. So the rotation matrix is an orthogonal matrix with
$det(bold(R)) = 1$ for right-handed frames and $det(bold(R)) = -1$ for
left-handed frames.

=== Properties of rotation matrices

- Composing (e.g. multiplying) two rotation matrices produces another rotation
  matrix.
- Rotations are associative:
  $bold(R)_1 (bold(R)_2 bold(R)_3) = (bold(R)_1 bold(R)_2) bold(R)_3$
- Every rotation matrix has a unique inverse matrix.
- Rotations are not commutative.

$op("SO")(3)$ is the set of all rotation matrices.
