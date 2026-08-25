---
description: "Query ClickHouse database using data-scientist agent"
allowed_tools: ["Task"]
---

# ClickHouse Query Agent

Analyzes your data request and executes ClickHouse queries using the data-scientist agent.

**Usage**: `/clickhouse [your analysis request]`

**Examples**:
- `/clickhouse analyze login funnel performance by merchant`
- `/clickhouse compare DoorDash vs competitors on dropoff rates`
- `/clickhouse show me sessions with NULL login methods`
- `/clickhouse create dashboard for user authentication analysis`

The data-scientist agent will:
1. Understand your analysis requirements
2. Generate appropriate ClickHouse SQL queries
3. Execute queries using `clickhouse client`
4. Analyze and interpret the results
5. Provide actionable insights and recommendations

**Arguments**: $ARGUMENTS

I'll analyze your request and execute ClickHouse queries to provide insights.

Using the Task tool to invoke the data-scientist agent with your query: "$ARGUMENTS"

The data-scientist agent has access to your ClickHouse database and will:

**Database Context:**
- **Primary Database**: ClickHouse with payment analytics data
- **Key Tables**: 
  - `appswitch_fpti_client_side_events` - Client-side events
  - `appswitch_fpti_server_side_events` - Server-side events  
  - `fpti_client_side_payload_parsed` - Parsed client payloads
  - `fpti_server_side_payload_parsed` - Parsed server payloads
  - `dw_app_switch_ssot` - Single source of truth for app switch data
  - `braintree_client_events` - Braintree client events

**Analysis Focus**: Payment authentication flows, login funnels, merchant performance comparison (especially DoorDash vs others)

**Execution Method**: Use `clickhouse client` commands to run generated SQL queries

**Analysis Patterns**: Follow established investigation methodology focusing on:
- Login render dropoff analysis
- Authentication method comparison (public_pg vs lls)
- Merchant-specific performance metrics
- User session flow analysis
- Error pattern identification

**Output Format**: Provide both raw query results and business insights with actionable recommendations.

Please analyze the request: "$ARGUMENTS" and execute appropriate ClickHouse queries to provide comprehensive insights.