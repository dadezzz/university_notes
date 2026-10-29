#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Data drives decisions, science and automation, but file-based storage brings redundancy, access, integrity, atomicity, concurrency and security problems.",
  lang: "en",
  prev: false,
  title: "Why data matters and the limits of file systems",
))

= The importance of data

Data is a fundamental part of modern life, making many things simpler and some
things possible.

Examples of situations that require knowledge of data:

- Informed decision-making: data allows us to see what actually works and to
  assess the effects of policies and actions.
- Personalization and convenience: algorithms use data to tailor experiences
  (e.g., movie recommendations and the fastest routes to avoid traffic).
- Scientific discovery, problem-solving and healthcare: data is used to track
  diseases, develop new medicines, model climate change, etc.
- Efficiency and automation: data helps streamline operations, optimize supply
  chains and automate repetitive tasks.

= Managing data

In the early days, applications for storing data were built directly on top of
file systems, leading to all sorts of problems:

- *redundancy and inconsistency*: data was stored in multiple formats, resulting
  in duplication and divergence;
- *difficulty of access*: each new task required writing a new program;
- *isolation*: multiple files and formats kept information scattered;
- *integrity*: integrity constraints became buried in the code instead of being
  stated explicitly;
- *atomicity*: failures could leave databases in an inconsistent state, with
  only partial updates applied;
- *concurrency*: concurrent reads and writes from multiple users were needed for
  performance, but could result in inconsistencies;
- *security*: it was hard to provide access to some data but not all of it;
