# GoodanalyticsEx

Elixir API client for [GoodAnalytics](https://goodanalytics.dev) — visitor intelligence, link tracking, source attribution, and behavioral analytics.

All client functions, schema structs, and decoders are generated at compile time from the OpenAPI spec using [CanOpener](https://github.com/agoodway/can_opener).

## Installation

Add `goodanalytics_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:goodanalytics_ex, git: "https://github.com/agoodway/goodanalytics_ex.git"}
  ]
end
```

## Configuration

Configure the default base URL and API key in `config/config.exs`:

```elixir
config :goodanalytics_ex, GoodanalyticsEx,
  base_url: "https://goodanalytics.dev",
  api_key: System.get_env("GOOD_ANALYTICS_API_KEY")
```

Or pass options at runtime:

```elixir
client = GoodanalyticsEx.client(
  base_url: "https://goodanalytics.dev",
  api_key: "sk_live_..."
)
```

## Authentication

GoodAnalytics uses Bearer token authentication. Pass your API key via config or the `api_key` option:

```elixir
client = GoodanalyticsEx.client(api_key: "sk_live_...")
# Sends: Authorization: Bearer sk_live_...
```

## Usage

### Links

```elixir
client = GoodanalyticsEx.client(api_key: "sk_live_...")

# List links
{:ok, links} = GoodanalyticsEx.list_links(client)

# Create a link
{:ok, link} = GoodanalyticsEx.create_link(client, %{
  domain: "go.example.com",
  key: "spring-sale",
  url: "https://example.com/products",
  utm_source: "email",
  utm_campaign: "spring-2026"
})

# Get a link
{:ok, link} = GoodanalyticsEx.get_link(client, link_id)

# Update a link
{:ok, link} = GoodanalyticsEx.update_link(client, link_id, %{
  url: "https://example.com/new-products"
})

# Archive a link
{:ok, _} = GoodanalyticsEx.archive_link(client, link_id)

# Get link stats
{:ok, stats} = GoodanalyticsEx.get_link_stats(client, link_id)

# Get link clicks
{:ok, clicks} = GoodanalyticsEx.get_link_clicks(client, link_id)
```

### Visitors

```elixir
# List visitors
{:ok, visitors} = GoodanalyticsEx.list_visitors(client)

# Get a visitor
{:ok, visitor} = GoodanalyticsEx.get_visitor(client, visitor_id)

# Lookup by external ID
{:ok, visitor} = GoodanalyticsEx.lookup_visitor(client, "user_123")

# Get attribution data
{:ok, attribution} = GoodanalyticsEx.get_visitor_attribution(client, visitor_id)

# Get timeline
{:ok, timeline} = GoodanalyticsEx.get_visitor_timeline(client, visitor_id)
```

### Events

```elixir
# Record a single event
{:ok, %{event_id: id}} = GoodanalyticsEx.create_event(client, %{
  event_type: "sale",
  person_external_id: "user_123",
  amount_cents: 4999,
  currency: "USD"
})

# Record events in batch (up to 100)
{:ok, results} = GoodanalyticsEx.batch_events(client, %{
  events: [
    %{event_type: "pageview", url: "/pricing", ga_id: "abc123"},
    %{event_type: "lead", person_email: "user@example.com"}
  ]
})
```

## Error Handling

```elixir
case GoodanalyticsEx.get_visitor(client, visitor_id) do
  {:ok, visitor} -> handle_visitor(visitor)
  {:error, %{status: 404, body: body}} -> handle_not_found(body)
  {:error, %{status: 422, body: body}} -> handle_validation(body)
  {:error, exception} -> handle_transport_error(exception)
end
```

## Schema Structs

All response schemas are generated as structs with `from_map/1` decoders:

| Schema | Description |
|--------|-------------|
| `GoodanalyticsEx.Schemas.LinkResponse` | Full link resource |
| `GoodanalyticsEx.Schemas.LinkStatsResponse` | Aggregated link statistics |
| `GoodanalyticsEx.Schemas.ClickResponse` | Link click event |
| `GoodanalyticsEx.Schemas.VisitorResponse` | Full visitor resource |
| `GoodanalyticsEx.Schemas.AttributionResponse` | Visitor attribution data |
| `GoodanalyticsEx.Schemas.TimelineResponse` | Visitor timeline event |
| `GoodanalyticsEx.Schemas.EventResponse` | Event creation response |
| `GoodanalyticsEx.Schemas.EventParams` | Event request body |
| `GoodanalyticsEx.Schemas.BatchEventParams` | Batch event request body |
| `GoodanalyticsEx.Schemas.BatchEventResponse` | Batch event response |
| `GoodanalyticsEx.Schemas.LinkParams` | Link creation request body |
| `GoodanalyticsEx.Schemas.LinkUpdateParams` | Link update request body |
| `GoodanalyticsEx.Schemas.ErrorResponse` | Error response body |

## Function Reference

| Function | Description |
|----------|-------------|
| `client/0`, `client/1` | Create an API client |
| `list_links/1` | List links |
| `create_link/2` | Create a link |
| `get_link/2` | Get a link |
| `update_link/3` | Update a link (PUT) |
| `update_link_2/3` | Update a link (PATCH) |
| `archive_link/2` | Archive a link |
| `get_link_clicks/2` | Get link clicks |
| `get_link_stats/2` | Get link stats |
| `list_visitors/1` | List visitors |
| `get_visitor/2` | Get a visitor |
| `lookup_visitor/2` | Lookup visitor by external ID |
| `get_visitor_attribution/2` | Get visitor attribution |
| `get_visitor_timeline/2` | Get visitor timeline |
| `create_event/2` | Record a single event |
| `batch_events/2` | Record multiple events |

## How It Works

`GoodanalyticsEx` uses a single `use CanOpener` macro that reads `openapi.json` at compile time and generates:

- **Client functions** for every operation in the spec
- **Schema structs** with `from_map/1` decoders for all request/response schemas
- **Type specs** for all generated functions

No runtime reflection, no code generation steps — everything is compiled into the module.

## License

Proprietary. Copyright GoodWay Group.
