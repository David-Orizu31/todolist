# Sui Todo List Smart Contract

A simple task management system on Sui blockchain.

## Features
- ✅ Create tasks with priority levels (1-3)
- ✅ Mark tasks as complete/incomplete
- ✅ Update task details
- ✅ Delete tasks
- ✅ Owner-only access control

## Deployment
- **Network**: Sui Testnet
- **Package ID**: 0x1aa678685461c751e548ae7f5b9e85365559e30ea6324989e1bdcc16243c9a08
- **Module**: simple_tasks
- **Deployed By**: David Orizu
- **Date**: December 10, 2024

## Contract Functions

### Entry Functions (Callable from transactions)
- `new_task(description: String, priority: u8)` - Create a new task
- `mark_complete(task: &mut Task)` - Mark task as completed
- `edit_task(task: &mut Task, description: String, priority: u8)` - Update task
- `remove_task(task: Task)` - Delete a task

### View Functions (Read-only)
- `get_description(task: &Task): String`
- `get_priority(task: &Task): u8`
- `is_completed(task: &Task): bool`
- `get_owner(task: &Task): address`

## Testing
```bash
sui move build
sui move test
```

**Result:** ✅ 2/2 tests passed

## How to Use

1. **Create a task:**
```bash
sui client call --package 0x1aa678685461c751e548ae7f5b9e85365559e30ea6324989e1bdcc16243c9a08 --module simple_tasks --function new_task --args "Buy groceries" 2 --gas-budget 10000000
```

2. **View your tasks:**
```bash
sui client objects
```

## Project Structure
```
todolist/
├── Move.toml
├── sources/
│   └── todolist.move
└── README.md
```

## License
MIT