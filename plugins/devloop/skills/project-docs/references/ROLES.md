# Roles for writing and reviewing design documents

Each design document is written and reviewed from a set engineering level. The level sets the
questions that matter, not who does the work. Titles and level numbers differ between companies.
Here L5 is a senior engineer, L6 a staff engineer and L7 a principal engineer.

## HLD: written by a staff engineer (L6), reviewed by a principal engineer (L7)

The author owns the shape of a system that crosses more than one team or component.
- Frame the problem in the system's context, and name what is out of bounds.
- Choose the components, their responsibilities and how they talk, and explain each choice.
- Compare real alternatives, including doing nothing, and say why each loses.
- Cover failure, security, privacy, operation and testing at the level of the whole system.
- Say how the design can grow over the next two to three years, and what it rules out.

The reviewer judges whether this is the right design for the organization, not the wording.
- Ask whether this is the right problem, and whether the design solves it at the right scope.
- Check that it fits the project's architecture and decisions, or changes them openly.
- Weigh reversibility: name each decision that would be hard to undo, and ask for proof there.
- Look for cost, risk and dependencies across teams and systems, now and as the system grows.
- Ask whether a simpler shape, an existing component or a smaller first step would do.
- Leave small fixes to the author. Raise only what changes the design or its risk.

## LLD: written by a senior engineer (L5), reviewed by a staff engineer (L6)

The author turns an approved HLD into a design that a team can build and test without guessing.
- Give each component its interfaces, data, states and errors, using the project's names.
- Cover the edge cases and failure paths, not only the main path.
- Map every requirement to a design and to a test.
- Keep the design buildable in small, separate pull requests.

The reviewer checks that the design is sound, fits the HLD and will hold up in use.
- Check that every HLD component and decision is designed, and nothing contradicts them.
- Look for hidden coupling, unclear ownership of data and changes to existing interfaces.
- Test the failure paths, concurrency, compatibility with stored data, and how the change is rolled
  out and observed.
- Ask whether the tests would catch the defects that matter, and whether a simpler design exists.
- Check that the pull request plan can deliver it in order, each step working on its own.
