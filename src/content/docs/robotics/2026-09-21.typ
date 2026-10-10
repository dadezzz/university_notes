#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Elementary rotation matrices, vector rotation, fixed versus current frames, composition of rotations, Euler angle parametrisation, and the gimbal lock.",
  lang: "en",
  title: "Rotation matrices, Euler angles, and gimbal lock",
))

= Elementary rotations

The fundamental rotations along the three axes are expressed by the following
matrices:

Rotation for an angle $gamma$ about the $x$-axis:

$
  bold(R)_(x)(gamma) = mat(
    delim: "[",
    1, 0, 0;
    0, cos(gamma), -sin(gamma);
    0, sin(gamma), cos(gamma)
  )
$

Rotation for an angle $beta$ about the $y$-axis:

$
  bold(R)_(y)(beta) = mat(
    delim: "[",
    cos(beta), 0, sin(beta);
    0, 1, 0;
    -sin(beta), 0, cos(beta)
  )
$

Rotation for an angle $alpha$ about the $z$-axis:

$
  bold(R)_(z)(alpha) = mat(
    delim: "[",
    cos(alpha), -sin(alpha), 0;
    sin(alpha), cos(alpha), 0;
    0, 0, 1
  )
$

Practically, inverting a rotation means applying another rotation with the
inverse of the angle. So we derive that $bold(R)^(-1)(alpha) = bold(R)(-alpha)$.

= Rotation of a vector

When staying in a fixed coordinate system, we can use transformation matrices to
apply rotations to a vector.

The distance of the vector from the center remains constant:
$norm(p)^2 = p^T p = (p')^T R^T R p' = (p')^T p'$

= Fixed vs current frame rotations

When applying rotations, we must distinguish between fixed frames and current
frames. In fixed frames we apply the rotation staying in the original frame; in
current frames we rotate by referring to the new frame after each rotation.

= Composition of rotation matrices

A rotation can be expressed as a sequence of partial rotations, each one defined
with respect to the previous one. All rotations are defined with respect to the
current frame, but there's an important distinction to keep in mind when
applying them.

- When applying a rotation from the current frame, the sequence of rotations is
  obtained by post-multiplying the matrices associated with each rotation.
- Instead, when applying the rotation from the fixed frame, the matrix of the
  later operation must be pre-multiplied to the matrices of the earlier
  rotations.

Let's say we have two rotations: $bold(R)_1^0 = R_(y)(phi)$ around the $y_0$
axis followed by $overline(bold(R))_2^1$ for angle $theta$, which happens around
$z_0$ (not the $z_1$ of the current frame).

We know how to do rotations in the current axis, so we can translate the fixed
axis rotation to:

$
  overline(bold(R))_2^1 = (bold(R)_1^0)^(-1) bold(R)_(z)(theta) bold(R)_1^0
$

which leads to:

$
  bold(R)_2^0 = bold(R)_1^0 overline(bold(R))_2^1 = bold(R)_1^0 (bold(R)_1^0)^(-1) bold(R)_(z)(theta) bold(R)_1^0 = bold(R)_(z)(theta) bold(R)_(y)(phi)
$

= Parametrisation of rotation matrices

A 3D rotation matrix has 9 elements, but a rotation can be completely specified
by three parameters (an element of $op("SO")(m)$ can be specified by
$m (m - 1) / 2$ parameters).

== Euler angles

A popular convention is the use of $x$, $y$, $z$ rotations about fixed axes
(known in aeronautics as roll-pitch-yaw or RPY).

Since the rotation is about fixed axes we have to pre-multiply:

$
  bold(R)_(e)(phi, theta, psi) = bold(R)_(z)(phi) bold(R)_(y)(theta) bold(R)_(x)(psi)
$

Let's introduce the notation $c_alpha = cos(alpha)$ and $s_alpha = sin(alpha)$.

We see that:

$
  bold(R)_(e)(phi, theta, psi) = mat(
    delim: "[",
    c_phi c_theta, c_phi s_theta s_psi - s_phi c_psi, c_phi s_theta c_psi + s_phi s_psi;
    s_phi c_theta, s_phi s_theta s_psi + c_phi c_psi, s_phi s_theta c_psi - c_phi s_psi;
    -s_theta, c_theta s_psi, c_theta c_psi
  )
$

Given a matrix
$bold(R) = mat(delim: "[", r_(1,1), r_(1,2), r_(1,3); r_(2,1), r_(2,2), r_(2,3); r_(3,1), r_(3,2), r_(3,3))$,
the inverse operation (finding the three angles) has two solutions:

$
  theta in (- pi / 2, pi / 2) arrow.double cases(
    phi = op("atan2")(r_(2,1), r_(1,1)),
    theta = op("atan2")(-r_(3,1), sqrt(r_(3,2)^2 + r_(3,3)^2)),
    psi = op("atan2")(r_(3,2), r_(3,3))
  ) \
  theta in (pi / 2, (3 pi) /2) arrow.double cases(
    phi = op("atan2")(-r_(2,1), -r_(1,1)),
    theta = op("atan2")(-r_(3,1), -sqrt(r_(3,2)^2 + r_(3,3)^2)),
    psi = op("atan2")(-r_(3,2), -r_(3,3))
  )
$

=== Gimbal lock

In Euler-based parametrisations, the three angles act as three independent
degrees of freedom.

At a pitch angle of $plus.minus pi /2$, the roll and yaw rotation axes become
aligned, resulting in the loss of a degree of freedom. This means that a
rotation around one axis can be replicated by a rotation around the other.

$
  bold(R)_(e)(phi, pi / 2, psi) = mat(
    delim: "[",
    0, s(psi - phi), c(psi - phi);
    0, c(psi - phi), -s(psi - phi);
    -1, 0, 0
  )
$

The real problem surfaces when we try to calculate the inverse, to find the
angles of the rotation. We can verify that in a gimbal lock situation, there are
infinitely many combinations of $phi$ and $psi$ that produce the same rotation
matrix.

#starlight.note([
  The singularity caused by gimbal lock means that the robot's arm can reach the
  same point in many different configurations, causing it to abruptly change
  position as it moves slightly.

  We want inverse functions that guarantee a smooth and continuous movement of
  the arm.
])
