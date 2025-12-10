// Copyright (c) 2024 Simple Todo List Contract
// SPDX-License-Identifier: MIT

/// A simple todo list module for Sui blockchain
/// Perfect for beginners learning Move
module todo_list::simple_tasks {
    // Clean imports - no duplicate aliases
    use std::string::String;

    // ====== Error Codes ======
    const ENotOwner: u64 = 1;
    const EInvalidPriority: u64 = 2;
    const ETaskAlreadyCompleted: u64 = 3;

    // ====== Priority Levels ======
    const PRIORITY_LOW: u8 = 1;
    const PRIORITY_HIGH: u8 = 3;

    // ====== Structs ======

    /// Individual Task object - simplified version
    public struct Task has key, store {
        id: UID,
        owner: address,
        description: String,
        priority: u8,
        completed: bool,
    }

    // ====== Core Functions ======

    /// Create a new task - simplified version
    /// priority: 1=Low, 2=Medium, 3=High
    public fun create_task(
        description: String,
        priority: u8,
        ctx: &mut TxContext
    ): Task {
        // Validate priority
        assert!(priority >= PRIORITY_LOW && priority <= PRIORITY_HIGH, EInvalidPriority);

        let task = Task {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            description,
            priority,
            completed: false,
        };

        task
    }

    /// Mark a task as completed
    public fun complete_task(
        task: &mut Task,
        ctx: &TxContext
    ) {
        assert!(tx_context::sender(ctx) == task.owner, ENotOwner);
        assert!(!task.completed, ETaskAlreadyCompleted);
        
        task.completed = true;
    }

    /// Reopen a completed task
    public fun reopen_task(
        task: &mut Task,
        ctx: &TxContext
    ) {
        assert!(tx_context::sender(ctx) == task.owner, ENotOwner);
        
        task.completed = false;
    }

    /// Update task details
    public fun update_task(
        task: &mut Task,
        description: String,
        priority: u8,
        ctx: &TxContext
    ) {
        assert!(tx_context::sender(ctx) == task.owner, ENotOwner);
        assert!(priority >= PRIORITY_LOW && priority <= PRIORITY_HIGH, EInvalidPriority);

        task.description = description;
        task.priority = priority;
    }

    /// Delete a task
    public fun delete_task(
        task: Task,
        ctx: &TxContext
    ) {
        assert!(tx_context::sender(ctx) == task.owner, ENotOwner);

        let Task {
            id,
            owner: _,
            description: _,
            priority: _,
            completed: _,
        } = task;

        object::delete(id);
    }

    // ====== Entry Functions for Direct Blockchain Calls ======

    /// Create and transfer task to sender
    entry fun new_task(
        description: String,
        priority: u8,
        ctx: &mut TxContext
    ) {
        let task = create_task(description, priority, ctx);
        transfer::transfer(task, tx_context::sender(ctx));
    }

    /// Complete task (entry point)
    entry fun mark_complete(
        task: &mut Task,
        ctx: &TxContext
    ) {
        complete_task(task, ctx);
    }

    /// Update task (entry point)
    entry fun edit_task(
        task: &mut Task,
        description: String,
        priority: u8,
        ctx: &TxContext
    ) {
        update_task(task, description, priority, ctx);
    }

    /// Delete task (entry point)
    entry fun remove_task(
        task: Task,
        ctx: &TxContext
    ) {
        delete_task(task, ctx);
    }

    // ====== View Functions ======

    /// Get task description
    public fun get_description(task: &Task): String {
        task.description
    }

    /// Get task priority
    public fun get_priority(task: &Task): u8 {
        task.priority
    }

    /// Check if task is completed
    public fun is_completed(task: &Task): bool {
        task.completed
    }

    /// Get task owner
    public fun get_owner(task: &Task): address {
        task.owner
    }

    // ====== Test Functions ======

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        let task = create_task(
            std::string::utf8(b"Test Task"),
            2,
            ctx
        );
        transfer::transfer(task, tx_context::sender(ctx));
    }

    #[test]
    fun test_create_task() {
        use sui::test_scenario;
        
        let admin = @0xABCD;
        let mut scenario = test_scenario::begin(admin);
        
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let task = create_task(
                std::string::utf8(b"My First Task"),
                2,
                ctx
            );
            assert!(task.priority == 2, 0);
            assert!(!task.completed, 1);
            transfer::transfer(task, admin);
        };
        
        test_scenario::end(scenario);
    }

    #[test]
    fun test_complete_task() {
        use sui::test_scenario;
        
        let admin = @0xABCD;
        let mut scenario = test_scenario::begin(admin);
        
        {
            let ctx = test_scenario::ctx(&mut scenario);
            let mut task = create_task(
                std::string::utf8(b"Complete Me"),
                1,
                ctx
            );
            
            complete_task(&mut task, ctx);
            assert!(task.completed, 0);
            
            transfer::transfer(task, admin);
        };
        
        test_scenario::end(scenario);
    }
}