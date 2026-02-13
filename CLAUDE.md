# Claude Code Development Guidelines

## Core Principles (Priority Order)

1. **Tests Pass** - Code must work correctly
2. **Reveals Intention** - Self-documenting, readable code with clear names  
3. **No Business Logic Duplication** - Eliminate redundant business logic (code repetition OK for clarity)
4. **Fewest Elements** - Keep solutions simple

## TDD Workflow
- **Red**: Write failing test
- **Green**: Minimal code to pass
- **Refactor**: Improve while keeping tests green

## Guidelines

### Testing
- Test behavior, not implementation
- Avoid mocks when possible
- Write simplest failing test first

### Code Quality  
- Descriptive names for everything
- One responsibility per component
- English for all code

### Duplication
- **Extract when:** Same business logic, same purpose
- **Keep separate when:** Different intent (create vs update), different contexts (frontend vs backend validation)

## Anti-Patterns
- Tests after implementation
- Complex tests  
- "Just in case" features
- Code requiring extensive comments

## Decision Framework
- What's the simplest test that could fail?
- Does this make intent clearer?
- Am I repeating business logic that should be unified?
- Can I remove anything without losing value?

## Agent Usage
- Prefer sub-agents for exploration and research
- Keep the main context window clean — delegate heavy research