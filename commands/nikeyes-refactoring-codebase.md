**CODEBASE REFACTORING COMMAND**

Think deeply about this code refactoring task. You are the orchestrator of a sophisticated, multi-agent process designed to improve the quality, safety, and conciseness of an existing codebase.

**Variables:**

focus_path: $ARGUMENTS
focus_on: $ARGUMENTS

**ARGUMENTS PARSING:**
Parse the following arguments from "$ARGUMENTS":
1.  `focus_path` - Path to the source code file or directory to be analyzed.
2.  `focus_on` - An optional natural language prompt providing specific context or areas of concern within the code.

**PHASE 1: CODEBASE ANALYSIS**
Read and deeply understand the code specified by `focus_path`.
-   If `focus_path` is a directory, recursively analyze all relevant source files (e.g., `.py` files).
-   If `focus_on` is provided, use it to narrow your focus and pay special attention to the described features or issues.
-   Construct a complete mental model of the codebase's architecture, dependencies, and existing patterns.

**PHASE 2: PROBLEM IDENTIFICATION (ULTRA-THINKING)**
Based on your analysis, engage in extended thinking to identify potential areas for improvement. Scrutinize the code against the four core principles of high-quality:

1.  **Remove Unnecessary Additions:**
    -   Features not explicitly requested.
    -   Extra logging/debugging code (`print` statements, extensive logs).
    -   Unnecessary abstractions or wrapper classes.
    -   Redundant or overly defensive error handling.
2.  **Improve Type Safety:**
    -   Presence of `Any` type.
    -   Missing or incomplete type hints on functions, methods, and variables.
    -   Opportunities to use `TypedDict` or `Pydantic` for complex data structures.
    -   Code that would not pass a strict `mypy` check.
3.  **Reduce Lines of Code (LOC):**
    -   Multiple similar functions that could be combined with parameters.
    -   Redundant boilerplate or repeated code blocks.
    -   Complex logic that could be simplified (e.g., nested conditionals).
    -   Loops or data manipulation that could be replaced with more concise Python idioms or built-ins (e.g., comprehensions).
4.  **Clean & Simplify:**
    -   Code that deviates from the dominant patterns of the existing codebase.
    -   Inclusion of unnecessary third-party dependencies.
    -   Implementations that are clever but not clear or concise.
    -   Signs of over-engineering for the given problem scope.

The output of this phase is a structured, internal list of all identified "problems". Write your list of problems into a markdown file named `OBS-MAIN.md`.

**PHASE 3: MASTER ARCHITECT CONSULTATION**
Deploy a specialized Sub Agent to validate and enrich your findings. This agent acts as a Master Code Architect.

**Agent Assignment Protocol:**
The Sub Agent receives:
1.  **Codebase Context**: Full access to the code at `focus_path`.
2.  **Problem List**: Instructions to read the internal list of problems you identified in Phase 2 (`OBS-MAIN.md`).
3.  **Architect Directive**: A precise instruction to review, validate, and document the problems.

**Architect Task Specification:**
```

TASK: Validate and Detail Code Refactoring Plan

You are a Master Code Architect. You have been provided with a codebase and a list of potential issues in `OBS-MAIN.md` you must read. Your task is to review this list, exercising your expert judgment to confirm, dismiss, or refine each point. Ultrathink.

For each *confirmed* problem, you must:

1.  Provide a clear and precise description of the issue.
2.  Cite a specific, real-world code snippet from the provided codebase that exemplifies the problem.
3.  Propose a clear, real-world solution, including a corrected code snippet.
4.  Assign a sequential number to each confirmed problem.

Your analysis must be rigorous and practical. Your goal is to create an actionable plan for the refactoring agents that will follow. The more complex is the task, the more precise instructions you will provide.

DELIVERABLE: Write your final, numbered list of findings, examples, and solutions into a markdown file named `OBS-MASTER-ARCHITECT.md`.

```

**Execution Management:**
-   Launch the Master Architect Sub Agent using the Task tool.
-   Wait for the agent to complete its task and for the `OBS-MASTER-ARCHITECT.md` file to be created.
-   If the agent fails, re-run this phase.

**PHASE 4: PARALLEL REFACTORING EXECUTION**
Once the architect's plan is ready, deploy three parallel Sub Agents to execute the refactoring tasks.

**Pre-computation:**
1.  Read and parse the `OBS-MASTER-ARCHITECT.md` file.
2.  Count the total number of tasks, `N`.

**Sub Agent Distribution Strategy:**
-   Assign tasks to the three agents using a modulo-based distribution to ensure a balanced workload.
-   **Agent 1** will handle tasks where `task_number % 3 == 1` (e.g., 1, 2, 3...).
-   **Agent 2** will handle tasks where `task_number % 3 == 2` (e.g., 4, 5, 6...).
-   **Agent 3** will handle tasks where `task_number % 3 == 0` (e.g., 7, 8, 9...).

**Agent Assignment Protocol:**
Each of the three Refactoring Sub Agents receives:
1.  **Codebase Context**: Full access to the code at `focus_path`.
2.  **Architect's Plan**: Instructions to read the complete contents of `OBS-MASTER-ARCHITECT.md`.
3.  **Task Assignment**: The specific list of task numbers it is responsible for.
4.  **Precision Directive**: An explicit instruction to *only* implement the solutions for its assigned tasks and to avoid modifying other parts of the code.

**Refactor Agent Task Specification:**
```

TASK: Execute Code Refactoring Tasks \#[YOUR\_ASSIGNED\_NUMBERS]

You are a Refactoring Agent. Your goal is to apply specific improvements to the codebase based on a master plan.

CONTEXT:

  - Codebase: focus\_path
  - Architect's Plan: Read `OBS-MASTER-ARCHITECT.md`
  - Your assigned task numbers: [List of task numbers, e.g., 1, 2, 3]

REQUIREMENTS:

1.  Read the Architect's Plan (`OBS-MASTER-ARCHITECT.md`) completely.
2.  For each of your assigned task numbers, locate the problem description and the proposed solution.
3.  Carefully apply the exact solution to the codebase.
4.  Ensure your changes are precise and do not introduce side effects.
5.  Do NOT address tasks that were not assigned to you.
6.  Once all your assigned tasks are complete, create a brief summary of the changes you made.

DELIVERABLE: Modified code files and a summary of actions taken in `SUMMARY_[AGENT_NUMBER].md`.

```

**Parallel Execution Management:**
-   Launch all three Refactoring Sub Agents simultaneously using the Task tool.
-   Monitor the agents for successful completion.
-   Handle any agent failures by re-launching the agent with the same task assignment.

**PHASE 5: FINAL SYNTHESIS AND SUMMARY**
After all parallel refactoring agents have successfully completed their work, your final task is to consolidate the results into `FINAL_SUMMARY.md`.

**Process:**
1.  Read the summary of actions from each of the three Sub Agents.
2.  Perform a final, quick review of the modified codebase to ensure coherence.
3.  Generate a global summary report that describes the overall refactoring process. This report should:
    -   Mention the initial problems identified by the Master Architect.
    -   Detail which agent handled which tasks.
    -   Confirm that all tasks from `OBS-MASTER-ARCHITECT.md` were successfully addressed.
    -   Provide a high-level overview of the improvements made to the codebase's quality, type safety, and conciseness.

This final summary is the conclusive output of the entire command.

Begin execution with deep analysis of these parallel coordination challenges and proceed systematically through each phase, leveraging Sub Agents for maximum creative output and efficiency.