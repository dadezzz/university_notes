#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  lang: "en",
  title: "Lesson (2026-09-23)",
))

= Pose of the end-effector

Given a fixed frame $b$ attached to the base and another frame $e$ attached to
the end-effector, the pose of the latter is given by the homogeneous
transformation matrix $T_e^b(bold(q))$, where $bold(q)$ is the $n$-vector of
joint variables.

$n_e$, $s_e$, $a_e$ are the unit vectors associated with the end-effector and
are chosen according to its geometry. For a two-fingered gripper, $a_e$ is
chosen in the approach direction, $s_e$ in the sliding direction, and $n_e$ is
orthogonal to the other two so that the frame is right-handed.

== Open chains

#starlight.img(
  "images/chain-of-transformations.png",
  alt: "Chain of transformations",
)

In the general case, we have an open chain of $n + 1$ links connected by $n$
joints (no loops between links).

By attaching a frame to each link, the pose of frame $i + 1$ is determined from
the pose of frame $i$, so finding the pose of the $n$-th link is a recursive
process starting from the base frame.

== Denavit-Hartenberg convention

#include "frames/denavit-hartenberg.typ"

In order to find the direct kinematics of an open chain, we need an effective
way to place the different frames.

The Denavit-Hartenberg convention proposes the following solution: frame $i$ is
attached to link $i$, and its axis $z_i$ is chosen aligned with the axis of
joint $i + 1$. We still have to choose $bold(0)_i$ and the axes $x_i$ and $y_i$.

The *common normal* to two lines is the line containing the minimum-distance
segment between them. It is uniquely defined when the lines are not coplanar;
there is an infinite number of common normals when the lines are coplanar and
parallel; and it degenerates to a single point when the lines are coplanar and
intersect.

- The origin $bold(0)_i$ is placed at the intersection between the common normal
  and the axis $z_i$, and $bold(0)_i'$ at its intersection with the axis
  $z_(i - 1)$.
- $x_i$ is chosen along the common normal in the direction from $z_(i - 1)$ to
  $z_i$.
- $y_i$ is chosen so that the frame is right-handed.

For frame $0$, only $z_0$ is specified, so its origin and $x$-axis can be
arbitrary. For frame $n$ there is no joint $n + 1$, so $z_n$ is not uniquely
defined; since joint $n$ is revolute, $z_n$ is aligned with $z_(n - 1)$.

We introduce the following parameters:

- $a_i$: distance between $bold(0)_i$ and $bold(0)_i'$;
- $d_i$: coordinate of $bold(0)_i'$ along $z_(i - 1)$;
- $alpha_i$: rotation angle between $z_(i - 1)$ and $z_i$ about $x_i$;
- $theta_i$: rotation angle between $x_(i - 1)$ and $x_i$ about $z_(i - 1)$;

#starlight.img(
  "images/denavit-hartenberg.png",
  alt: "Arm with Denavit-Hartenberg parameters",
)

=== Construction of the transformation matrix

To build the transformation matrix between link $i - 1$ and link $i$:

- We start from frame $i - 1$ and translate it by $d_i$ along $z_(i - 1)$ and
  rotate it by $theta_i$ about $z_(i - 1)$, aligning it with frame $i'$.

  $
    A_(i')^(i - 1) = mat(
      delim: "[",
      c_theta_i, -s_theta_i, 0, 0;
      s_theta_i, c_theta_i, 0, 0;
      0, 0, 1, d_i;
      0, 0, 0, 1;
    )
  $

- Then we translate frame $i'$ by $a_i$ along $x_i'$ and rotate it by $alpha_i$
  about $x_i'$, aligning it with frame $i$.

  $
    A_i^i' = mat(
      delim: "[",
      1, 0, 0, a_i;
      0, c_alpha_i, -s_alpha_i, 0;
      0, s_alpha_i, c_alpha_i, 0;
      0, 0, 0, 1;
    )
  $

The end result is:

$
  A_i^(i - 1) = mat(
    delim: "[",
    c_theta_i, -s_theta_i c_alpha_i, s_theta_i s_alpha_i, a_i c_theta_i;
    s_theta_i, c_theta_i c_alpha_i, -c_theta_i s_alpha_i, a_i s_theta_i;
    0, s_alpha_i, c_alpha_i, d_i;
    0, 0, 0, 1;
  )
$
