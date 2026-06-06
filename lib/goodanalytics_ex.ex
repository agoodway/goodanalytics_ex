defmodule GoodanalyticsEx do
  @moduledoc """
  API client for GoodAnalytics.

  Create a client with `client/1`, then call the generated functions.

      client = GoodanalyticsEx.client(base_url: "https://goodanalytics.dev/ga/api", api_key: "sk_...")

      {:ok, visitors} = GoodanalyticsEx.list_visitors(client)

  ## Analytics

  The analytics endpoints require query parameters (`dimension`, `from`, `to`, etc.).
  Use the arity-2 wrappers instead of the CanOpener-generated arity-1 functions:

      {:ok, result} = GoodanalyticsEx.analytics_breakdown(client, %{
        dimension: "device_type",
        from: "2026-06-01T00:00:00Z",
        to: "2026-06-30T00:00:00Z"
      })
  """

  use CanOpener,
    spec: "openapi.json",
    otp_app: :goodanalytics_ex,
    base_url: "https://goodanalytics.dev/ga/api",
    auth: :bearer,
    path_prefix: "/ga/api/"

  alias CanOpener.Client
  alias GoodanalyticsEx.Schemas.AnalyticsSummaryResponse
  alias GoodanalyticsEx.Schemas.BreakdownResponse
  alias GoodanalyticsEx.Schemas.TimeseriesResponse

  @analytics_paths %{
    breakdown: "/analytics/breakdown",
    timeseries: "/analytics/timeseries",
    summary: "/analytics/summary"
  }

  @doc "Audience breakdown. `params` is a map of query params (dimension, from, to, metrics, filter, limit, order)."
  def analytics_breakdown(%Client{} = client, params) when is_map(params),
    do: analytics_get(client, :breakdown, params, BreakdownResponse)

  @doc "Bucketed timeseries. `params`: metric, from, to, interval, timezone."
  def analytics_timeseries(%Client{} = client, params) when is_map(params),
    do: analytics_get(client, :timeseries, params, TimeseriesResponse)

  @doc "Headline KPIs. `params`: from, to."
  def analytics_summary(%Client{} = client, params) when is_map(params),
    do: analytics_get(client, :summary, params, AnalyticsSummaryResponse)

  defp analytics_get(client, key, params, response_module) do
    case Client.request(client, :get, @analytics_paths[key], params: params) do
      {:ok, body} when is_map(body) -> {:ok, CanOpener.decode_response(response_module, body)}
      other -> other
    end
  end
end
