# System Design: Building Scalable Applications

## Introduction

System design is the art of building large-scale applications that are reliable, scalable, and maintainable. It requires understanding trade-offs and making informed architectural decisions.

## Core Principles

### 1. Scalability
- **Vertical**: Add more resources to single machine
- **Horizontal**: Distribute load across multiple machines
- **Database**: Sharding, replication, caching

### 2. Availability
- **Redundancy**: Eliminate single points of failure
- **Failover**: Automatic recovery mechanisms
- **Load Balancing**: Distribute requests evenly

### 3. Consistency vs Availability (CAP Theorem)
- Can't have all three: Consistency, Availability, Partition tolerance
- Choose based on requirements

## Key Architecture Patterns

### Microservices
- Independent, loosely-coupled services
- Own databases
- Inter-service communication
- Easier to scale individual services

### Monolith
- Single unified codebase
- Shared database
- Simpler initially
- Harder to scale as complexity grows

### Hybrid
- Combine monolith and microservices
- Gradual migration path

## Critical Components

### Load Balancer
- Distributes incoming traffic
- Health checks for backend servers
- Session persistence
- Examples: Nginx, HAProxy

### Cache Layer
- Reduces database load
- Improves response times
- Examples: Redis, Memcached

### Message Queue
- Asynchronous processing
- Decouples services
- Examples: RabbitMQ, Kafka

### Database
- Relational: PostgreSQL, MySQL
- NoSQL: MongoDB, Cassandra
- Choose based on access patterns

## Performance Metrics

### Latency
- Time to process request
- Target: < 100ms for web applications

### Throughput
- Requests per second
- Scale based on requirements

### Availability
- Uptime percentage (99.9%, 99.99%, etc.)
- SLA requirements

## Design Example: URL Shortener

### Requirements
- Shorten long URLs
- Redirect to original URL
- High throughput, low latency

### Architecture
```
Client → Load Balancer → API Servers → Cache (Redis) → Database
                                     ↑
                              Rate Limiter
```

### Key Decisions
- Use cache for frequently accessed links
- Sharding for database scalability
- Multiple API servers behind load balancer
- Rate limiting to prevent abuse

## Conclusion

System design is about making trade-offs. There's no one-size-fits-all solution. Understand requirements, constraints, and choose architectures accordingly.
