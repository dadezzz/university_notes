#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Axis-angle parameterisation as a gimbal-lock-free alternative, quaternion algebra, rotations via Rodrigues' formula, and homogeneous coordinate transforms.",
  lang: "en",
  title: "Axis-angle, quaternion, and homogeneous transforms",
))

= Axis-angle parameterisation

To solve the gimbal lock problem, we can adopt a redundant parameterisation
using an axis $bold(k) = [k_x, k_y, k_z]$ with $norm(bold(k)) = 1$ and an angle
$theta$, resulting in four parameters overall.

The rotation $bold(R)_bold(k)(theta)$ can be found by transforming the
coordinates of $bold(k)$:

+ Given frame $1$ with axes $x_1, y_1, z_1$ (with $z_1$ coincident with
  $bold(k)$), we can rotate frame $0$ by $alpha$ about the $z$-axis and by
  $beta$ around the $y$-axis.

  $
    bold(R)_1^0 = bold(R)_(z)(alpha) bold(R)_(y)(beta)
  $

+ If a transformation $bold(A)$ is expressed in frame $1$ as
  $q_1 = bold(A) p_1$, then:

  $
    q_0 = (bold(R)_0^1)^(-1) bold(A) bold(R)_0^1 p^0 = bold(R)_(z)(alpha) bold(R)_(y)(beta) bold(A) (bold(R)_(z)(alpha) bold(R)_(y)(beta))^(-1)
  $

  which leads to:

  $
    bold(R)_bold(k)(theta) = bold(R)_(z)(alpha) bold(R)_(y)(beta) bold(R)_(z)(theta) bold(R)_(y)(-beta) bold(R)_(z)(-alpha)
  $

+ Using trigonometry we can find $alpha$ and $beta$:

  $
    sin(alpha) = k_y / sqrt(k_(x)^2 + k_(y)^2) \
    cos(alpha) = k_x / sqrt(k_(x)^2 + k_(y)^2) \
    sin(beta) = sqrt(k_(x)^2 + k_(y)^2) \
    cos(beta) = k_z
  $

The rotation matrix is:

$
  bold(R)_bold(k)(theta) = mat(
    delim: "[",
    k_(x)^2 (1 - c_theta) + c_theta, k_x k_y (1 - c_theta) - k_z s_theta, k_x k_z (1 - c_theta) + k_y s_theta;
    k_x k_y (1 - c_theta) + k_z s_theta, k_(y)^2 (1 - c_theta) + c_theta, k_y k_z (1 - c_theta) - k_x s_theta;
    k_x k_z (1 - c_theta) - k_y s_theta, k_y k_z (1 - c_theta) + k_x s_theta, k_(z)^2 (1 - c_theta) + c_theta
  )
$

We specified four parameters ($bold(k)$ and $theta$), but there's the constraint
$k_(x)^2 + k_(y)^2 + k_(z)^2 = 1$, so the system actually has three degrees of
freedom.

We can see that $bold(R)_(-bold(k))(-theta) = bold(R)_(bold(k))(theta)$.

The axis-angle parameterisation isn't globally invertible. However, it is
locally invertible, which means that unlike the Euler one, there are no
singularities such as gimbal lock.

= Quaternions

The inverse of a real number $x$ is $x^(-1) = 1 / x$, which, when multiplied by
$x$, gives 1.

For complex numbers we can find a similar concept: a number $z$ multiplied by
its inverse $overline(z) / norm(z)^2$ still gives 1.

There is no equivalent concept in $bb(R)^3$, but it exists in $bb(R)^4$.

A *quaternion* is an element of a vector space over the reals with the form
$q = q_0 + q_1 bold(i) + q_2 bold(j) + q_3 bold(k)$ where
${1, bold(i), bold(j), bold(k)}$ is the basis set.

#starlight.tip([
  A shorthand notation distinguishes the scalar part from the vector part:

  $
    q = [q_0, bold(q)] = q_0 + bold(q)
  $
])

== Quaternion product

Let's define an axiom for quaternion bases:

$
  i^2 = j^2 = k^2 = i j k = -1
$

from which we can derive the multiplication rules between any two basis
elements:

$
  i j = k quad j i = -k \
  j k = i quad k j = -i \
  k i = j quad i k = -j
$

To compute the product of quaternions we can use the shorthand notation:

$
  p q = (p_0 + bold(p)) (q_0 + bold(q)) = p_0 q_0 + p_0 bold(q) + q_0 bold(p) + bold(p) bold(q)
$

Using the rules from the axiom above, the product of the vector parts can be
simplified as $bold(p) bold(q) = - bold(p) dot bold(q) + bold(p) times bold(q)$.
Thus the full product, with scalar and vector parts grouped, is:

$
  p q = (p_0 q_0 - bold(p) dot bold(q)) + (p_0 bold(q) + q_0 bold(p) + bold(p) times bold(q))
$

== Quaternion conjugate

For a quaternion $q = q_0 + q_1 bold(i) + q_2 bold(j) + q_3 bold(k)$, the
conjugate is:

$
  overline(q) = q_0 - q_1 bold(i) - q_2 bold(j) - q_3 bold(k)
$

The real number
$norm(q) = sqrt(q overline(q)) = sqrt(q_0^2 + q_1^2 + q_2^2 + q_3^2)$ is the
norm of the quaternion.

== Inverse of a quaternion

A quaternion (except 0) has a unique inverse $q^(-1) = overline(q) / norm(q)^2$.

== Quaternion rotations

Let's go back to complex numbers. Recall that they can also be expressed in
polar coordinates as $z = rho (cos(theta) + j sin(theta))$.

Multiplying two complex numbers rotates the resulting vector, especially when
both have unit norm:

$
  z_1 z_2 = rho_1 (cos(theta_1) + j sin(theta_1)) rho_2 (cos(theta_2) + j sin(theta_2)) = rho_1 rho_2 (cos(theta_1 + theta_2) + j sin(theta_1 + theta_2))
$

Let's consider a unit-length quaternion $q = [eta, bold(epsilon)]$. We can
express it as $q = [cos(theta / 2), sin(theta / 2) bold(k)]$ where $bold(k)$ is
a unit vector defined as $bold(k) = bold(epsilon) / norm(bold(epsilon))$ and
$theta = 2 op("atan")_2(norm(bold(epsilon)), eta)$.

The quaternion $q$ represents a rotation of angle $theta$ about the axis defined
by the vector $bold(k)$.

Let's take a pure quaternion $p = [0, bold(p)]$. The vector $p'$ rotated by $q$
can be computed using $p' = q p overline(q)$ which yields a quaternion of the
form $[0, bold(p)']$.

$
  bold(p)' = (eta^2 - norm(bold(epsilon))^2) bold(p) + 2 eta (bold(epsilon) times bold(p)) + 2 (bold(epsilon) dot bold(p)) bold(epsilon)
$

Substituting $theta$ and $bold(k)$, we obtain Rodrigues' rotation formula that
describes the rotation of the vector $bold(p)$:

$
  bold(p)' = cos(theta) bold(p) + sin(theta) (bold(k) times bold(p)) + (1 - cos(theta)) (bold(k) dot bold(p)) bold(k)
$

#starlight.note([
  The formula is equivalent to applying the rotation from the matrix given by
  the axis-angle parameterisation.
])

The parameters of a unit-length quaternion correspond to three degrees of
freedom, which can be expressed as:

- $eta$, $epsilon_x$, $epsilon_y$, $epsilon_z$, with the constraint
  $eta^2 + epsilon_x^2 + epsilon_y^2 + epsilon_z^2 = 1$;
- $theta$, $k_x$, $k_y$, $k_z$, with the constraint $k_x^2 + k_y^2 + k_z^2 = 1$;

=== Finding parameters from the rotation

Given a rotation matrix
$bold(R) = mat(delim: "[", r_(1, 1), r_(1, 2), r_(1, 3); r_(2, 1), r_(2, 2), r_(2, 3); r_(3, 1), r_(3, 2), r_(3, 3))$,
we can find the parameters:

$
  eta = 1 / 2 sqrt(r_(1, 1) + r_(2, 2) + r_(3, 3) + 1) \
  bold(epsilon) = 1 / 2 mat(
    op("sgn")(r_(3, 2) - r_(2, 3)) sqrt(r_(1, 1) - r_(2, 2) - r_(3, 3) + 1);
    op("sgn")(r_(1, 3) - r_(3, 1)) sqrt(-r_(1, 1) + r_(2, 2) - r_(3, 3) + 1);
    op("sgn")(r_(2, 1) - r_(1, 2)) sqrt(-r_(1, 1) - r_(2, 2) + r_(3, 3) + 1)
  )
$

=== Composition of rotations

Let's consider two rotations associated with the unit-length quaternions $q_0$
and $q_1$. The first rotation transforms a vector $bold(p)$ into $bold(p)'$ and
the second transforms $bold(p)'$ into $bold(p)''$.

$
  bold(p)'' = q_1 p' overline(q_1) = q_1 (q_0 p overline(q_0)) overline(q_1) = (q_1 q_0) p overline((q_1 q_0))
$

#starlight.note([
  The conjugate of a product is the product of the conjugates in reverse order.
])

The composition of rotations is the product of their corresponding quaternions.

= Translations

#starlight.img(
  "images/2-frames-traslated.png",
  alt: "One frame translated and rotated with respect to the other",
)

A point $bold(p)^1$ in frame $1$ can be expressed in frame $0$ as
$bold(p)^0 = bold(o)_1^0 + bold(R)_1^0 bold(p)^1$.

The inverse relation is found by isolating $bold(p)^1$:

$
  bold(p)^1 = bold(R)_0^1 bold(p)^0 - bold(R)_0^1 bold(o)_1^0
$

== Homogeneous coordinates

We need a compact way to represent both rotation and translation.

To do that, we create the homogeneous representation $tilde(bold(p))$ of
$bold(p)$ by appending a coordinate with value 1.

The homogeneous transformation matrix is defined as:

$
  bold(A)_1^0 = mat(delim: "[", bold(R)_1^0, bold(o)_1^0; bold(0)^T, 1)
$

which can then be used as usual to apply transformations by multiplying with
vectors:

$
  tilde(bold(p))^0 = bold(A)_1^0 tilde(bold(p))^1
$

The inverse transformation can be found by inverting the matrix:

$
  bold(A)_0^1 = (bold(A)_1^0)^(-1) = mat(delim: "[", (bold(R)_1^0)^T, -(bold(R)_1^0)^T bold(o)_1^0; bold(0)^T, 1)
$

Unlike rotation matrices, homogeneous transformations are not orthogonal, so
$bold(A)^(-1) != bold(A)^T$. But they can still be composed using matrix
multiplication.

