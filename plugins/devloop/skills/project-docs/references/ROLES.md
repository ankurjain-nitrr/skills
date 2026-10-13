# Roles for writing and reviewing design documents

Each design document is written and reviewed from a set engineering level. The level sets the
questions that matter, not who does the work. Titles and level numbers differ between companies.
Here L5 is a senior engineer, L6 a staff engineer and L7 a principal engineer.

## PRD: written by a senior product manager, reviewed by a principal product manager and a staff engineer (L6)

The author scopes one change request into requirements that a team can build and verify.
- State the problem from the user's side, with who has it and what it costs them today.
- Turn each ask in the request into a requirement with an acceptance test, or name it out of scope.
- Set goals, non-goals and success metrics with a baseline and a target.
- Keep solutions out: say what the product must do, not how it is built.
- Ask the requester about anything that changes the outcome, and record the rest as assumptions.

The reviewer judges the change at the level of the whole product, not the single request.
- Ask whether the change serves the product's goals and users, and whether it is worth doing now.
- Check that it fits the project's PRD: no conflict, no duplicate, and no silent change to settled
  behavior. Name each settled requirement it changes.
- Weigh it against the queued changes: overlap, order and whether part of it belongs elsewhere.
- Check that the metrics would show success or failure, and that the scope is the smallest that
  delivers the value.
- Leave wording fixes to the author. Raise only what changes the scope, the value or the risk.

The staff engineer (L6) reviews the same PRD for whether it can be built and checked.
- Check that each requirement is clear enough to design and test, with no hidden solution in it.
- Flag requirements that are very costly, risky or impossible with the current system, and say why.
- Check that every acceptance test and metric can actually be measured.
- Name technical constraints or dependencies the PRD should state as assumptions.

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

## LLD: written by a senior engineer (L5), reviewed by a staff engineer (L6) and an engineer (L4)

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

The engineer (L4) checks the same LLD against the code as it is today.
- Check that every file, function, field, route and test the LLD names exists, or is clearly new.
- Check that each claim about current behavior is true, by reading the code it describes.
- Find the call sites and tests that the change touches but the LLD doesn't mention.
- Flag any step that can't be built as written, such as a missing hook or a type that doesn't fit.
