# CS186-Database
- Rockie DB:
  - Indexing with B+ Tree:

    1. Read node from disk
    2. Recursively design B+ Tree
    3. Scan the table with B+ Tree
  - Joins and Query Optimization
    1. Nested Loop Joins
        - Simple Nested Loop Join
        - Page Nested Loop Join
        - Block Nested Loop Join
     2. Hash Joins
        - Simple Hash Join
        - Grace Hash Join
     3. External Sort
        - Sort Merge Join
  - Concurrency
    1. A queuing system for locks
    2. Multigranularity Locking
        - Locktype: S, X, IS, IX, SIX 
        - Lock Acquire, Release, Promote, Esclate
        - Compatibility Check
        - Two-Phase Locking
  - Recovery
    1. Implement forward processing when DB is under normal operation
        - Transaction Status
        - Logging
        - Savepoints
        - Checkpoints
    2. Implement phases of ARIE recovery algorithm
        - Analysis of logging
        - Redo logging
        - Undo logging
- Others:
  - SQL practice
  - MongoDB practice

