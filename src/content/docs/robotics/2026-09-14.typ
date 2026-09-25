#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Defines robots and their decision paradigms, models manipulator and mobile robot structures, and derives the forward and inverse kinematics of a two-link arm.",
  lang: "en",
  prev: false,
  title: "Robot paradigms, manipulator types, and kinematics",
))

= Robots

'Robot' is a Czech word, 'robota', meaning 'forced labour'. It was introduced by
a playwright in the 1920s and became famous from science fiction publications.

#quote(block: true, [
  A robot is a machine that can *move* and do some of the work of a person and
  is usually *controlled by a computer*.
])

Some common abilities of robots are:

- Estimating their position (or more generally their current state) in the
  environment.
- Sensing the environment and creating a map.
- Taking a decision based on their current knowledge.
- Taking an action to implement the decision.

== Intelligence

The intelligence of the system is concentrated in two different aspects:

- *perception* of the surrounding environment and of itself in the environment;
- *decision* of what to do and how to do it;

=== Deliberative paradigm

The deliberative paradigm is a top-down philosophy where the robot senses the
world and constructs an updated model of the environment, then plans a course of
action and implements the plan.

All the decisions are taken after a thorough deliberation procedure, so planning
is prominent since we will not make corrections before the next sensing
operation.

Due to the increased complexity required to preventively avoid all problem
sources, the system needs to process a lot of data and is therefore quite slow.

=== Reactive paradigm

In the reactive paradigm, every action taken by the robot is an immediate
response to sensed data. The system stores several sensing/reaction pairs that
operate concurrently.

The robot has no memory; it merely executes in reaction to what it senses in the
environment, so specific conditions may cause it to deviate from its intended
course.

=== Hybrid paradigm

In the hybrid paradigm, the robot plans how to best decompose a task into
subtasks and then calculates which behaviours are suitable to accomplish each
subtask.

The subtasks execute as in the reactive paradigm, allowing the robot to react to
local problematic situations.

= Modelling robots

Modelling robots means creating a mathematical representation of the environment
in which the robot operates and of the reactions it has to take.

The representation has to be mathematical to obtain reliable and predictable
behaviour.

== Terminology

/ Manipulators: robots with a fixed base, made to mechanically manipulate things
  (treated in this course).
/ Mobile robots: robots with a mobile base.

A robotic manipulator consists of an arm ensuring mobility, a wrist located at
the end of the arm and an end-effector executing the robot's tasks.

#starlight.img("images/manipulator-arm.png", alt: "Manipulator robot arm")

*Joints* provide the structure with its necessary mobility. They can be of two
types:

- prismatic joints: enable a relative translational motion between the links
  (e.g. a telescopic arm that extends);
- rotational joints: enable a relative rotational motion between the links (e.g.
  those in the wrist);

#starlight.img("images/joint-types.png", alt: "Joint types on robot arm")

/ Degree of freedom (DoF): Defines a specific mode in which the robot can move.
  Typically each joint is endowed with an actuator and provides the structure
  with one degree of freedom.
/ Dexterity: A robot's ability to cope with a variety of objects and actions.
/ Stiffness: Ability of a body to resist deformation. In the robot's case it
  indicates the amount of force required to induce an (unwanted) motion along a
  DoF.

The *workspace* of a robot is the set of all the points that can be reached by
the end-effector.

= Types of arms

- *Cartesian manipulator*: characterised by three prismatic joints, with three
  mutually orthogonal axes. The workspace is a parallelepiped.

  #starlight.img(
    "images/cartesian-manipulator.png",
    alt: "Workspace of a cartesian manipulator",
  )

  It operates with good mechanical stiffness and accuracy everywhere in its
  workspace, but its structure limits its dexterity.

- *Cylindrical manipulator*: one of the joints is replaced by a revolute joint.
  The workspace is a portion of a cylinder.

  #starlight.img(
    "images/cylindrical-manipulator.png",
    alt: "Workspace of cylindrical manipulator",
  )

  Good stiffness, but the wrist's accuracy decreases with the horizontal stroke.

- *Spherical manipulator*: two prismatic joints are replaced with revolute
  joints. The workspace is a portion of a hollow sphere.

  #starlight.img(
    "images/spherical-manipulator.png",
    alt: "Workspace of a spherical manipulator",
  )

  The manipulator has reduced accuracy when the radial stroke increases.

- *SCARA manipulator*: two revolute joints and one prismatic joint.

  #starlight.img(
    "images/scara-manipulator.png",
    alt: "Workspace of a SCARA manipulator",
  )

  It has high stiffness under vertical loads. The positioning accuracy decreases
  with the distance from the first axis.

- *Anthropomorphic manipulator*: three rotational joints. The axes of the second
  and third joints are orthogonal to the axis of the first.

  #starlight.img(
    "images/anthropomorphic-manipulator.png",
    alt: "Workspace of an anthropomorphic manipulator",
  )

  This is the robot with the most dexterity, but the accuracy varies depending
  on the position in the workspace.


== Wrist

All the different manipulators have an end-effector attached to a wrist. The
configuration of the wrist that maximises dexterity is spherical (three revolute
joints).

= Mobile robots

A mobile robot is characterised by a mobile base.

/ Wheeled robots: they have a rigid body (chassis) and a system of wheels that
  provide motion with respect to the ground.
/ Legged robots: they move through the movement of multiple rigid bodies
  connected through revolute and sometimes prismatic joints.

Wheeled robots use three types of wheels:

- *Fixed*: only the wheel rotates;
- *Steerable*: the wheel can steer around a vertical axis that passes through
  its middle;
- *Caster*: the vertical steering axis is offset from the centre of the wheel;

#starlight.img("images/wheels.png", alt: "The three wheel types")

- Differential drive robots have two actuated wheels on the same axis (and a
  third caster wheel for stability). The robot can rotate by applying a
  different velocity to the two wheels.
- Tricycle robots have two fixed wheels actuated by a motor; a third wheel is
  steerable and is governed by another motor.


Unlike manipulators, mobile robots don't have a limited workspace; however, they
do have motion constraints (e.g. a differential robot cannot move sideways).

= Geometric background

Consider a robot arm fixed to a point.

#starlight.img("images/geometry-arm-angles.png", alt: "Robot arm with angles")

The position of the point $bold(p)$ (forward kinematics) is given by the
following:

$
  p_x = l_1 cos(q_1) + l_2 cos(q_1 + q_2) \
  p_y = l_1 sin(q_1) + l_2 sin(q_1 + q_2) \
  phi = q_1 + q_2
$

For the inverse kinematics we use:

$
  q_1 = op("atan2")((p_y - l_2 sin(phi)) / l_1, (p_x - l_2 cos(phi)) / l_1) \
  q_2 = phi - q_1
$

Wikipedia: #link("https://en.wikipedia.org/wiki/Atan2")[Atan2]

#starlight.caution([
  Notice that for the inversion formula, in case $phi$ is not known, there are
  two solutions, since the arm can reach point $bold(p)$ through two different
  configurations (the one in the figure and its mirror image).
])

u
