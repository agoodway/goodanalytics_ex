defmodule GoodanalyticsExTest do
  use ExUnit.Case

  alias CanOpener.Client

  # CanOpener generates the client functions at compile time; force the module
  # to load before any `function_exported?/3` checks so a fresh test VM does not
  # race module loading (which would intermittently report functions as absent).
  setup_all do
    Code.ensure_loaded!(GoodanalyticsEx)
    :ok
  end

  test "creates an API client with defaults" do
    assert %Client{base_url: "https://goodanalytics.dev/ga/api", auth: nil} =
             GoodanalyticsEx.client()
  end

  test "accepts explicit client options" do
    client = GoodanalyticsEx.client(base_url: "https://api.example.test", api_key: "sk_test")

    assert client.base_url == "https://api.example.test"
    assert client.auth == {:bearer, "sk_test"}
  end

  describe "generated schemas" do
    test "LinkResponse" do
      assert %GoodanalyticsEx.Schemas.LinkResponse{} =
               GoodanalyticsEx.Schemas.LinkResponse.from_map(%{})
    end

    test "VisitorResponse" do
      assert %GoodanalyticsEx.Schemas.VisitorResponse{} =
               GoodanalyticsEx.Schemas.VisitorResponse.from_map(%{})
    end

    test "EventResponse" do
      assert %GoodanalyticsEx.Schemas.EventResponse{} =
               GoodanalyticsEx.Schemas.EventResponse.from_map(%{})
    end

    test "EventParams" do
      assert %GoodanalyticsEx.Schemas.EventParams{} =
               GoodanalyticsEx.Schemas.EventParams.from_map(%{})
    end

    test "AttributionResponse" do
      assert %GoodanalyticsEx.Schemas.AttributionResponse{} =
               GoodanalyticsEx.Schemas.AttributionResponse.from_map(%{})
    end

    test "TimelineResponse" do
      assert %GoodanalyticsEx.Schemas.TimelineResponse{} =
               GoodanalyticsEx.Schemas.TimelineResponse.from_map(%{})
    end

    test "ClickResponse" do
      assert %GoodanalyticsEx.Schemas.ClickResponse{} =
               GoodanalyticsEx.Schemas.ClickResponse.from_map(%{})
    end

    test "LinkStatsResponse" do
      assert %GoodanalyticsEx.Schemas.LinkStatsResponse{} =
               GoodanalyticsEx.Schemas.LinkStatsResponse.from_map(%{})
    end

    test "BatchEventResponse" do
      assert %GoodanalyticsEx.Schemas.BatchEventResponse{} =
               GoodanalyticsEx.Schemas.BatchEventResponse.from_map(%{})
    end

    test "BreakdownResponse" do
      assert %GoodanalyticsEx.Schemas.BreakdownResponse{} =
               GoodanalyticsEx.Schemas.BreakdownResponse.from_map(%{})
    end

    test "BreakdownRow" do
      assert %GoodanalyticsEx.Schemas.BreakdownRow{} =
               GoodanalyticsEx.Schemas.BreakdownRow.from_map(%{})
    end

    test "TimeseriesResponse" do
      assert %GoodanalyticsEx.Schemas.TimeseriesResponse{} =
               GoodanalyticsEx.Schemas.TimeseriesResponse.from_map(%{})
    end

    test "TimeseriesPoint" do
      assert %GoodanalyticsEx.Schemas.TimeseriesPoint{} =
               GoodanalyticsEx.Schemas.TimeseriesPoint.from_map(%{})
    end

    test "AnalyticsSummaryResponse" do
      assert %GoodanalyticsEx.Schemas.AnalyticsSummaryResponse{} =
               GoodanalyticsEx.Schemas.AnalyticsSummaryResponse.from_map(%{})
    end

    test "PartnerResponse" do
      assert %GoodanalyticsEx.Schemas.PartnerResponse{} =
               GoodanalyticsEx.Schemas.PartnerResponse.from_map(%{})
    end
  end

  describe "generated operations" do
    test "links operations" do
      assert function_exported?(GoodanalyticsEx, :list_links, 1)
      assert function_exported?(GoodanalyticsEx, :create_link, 2)
      assert function_exported?(GoodanalyticsEx, :get_link, 2)
      assert function_exported?(GoodanalyticsEx, :update_link, 3)
      assert function_exported?(GoodanalyticsEx, :archive_link, 2)
      assert function_exported?(GoodanalyticsEx, :get_link_clicks, 2)
      assert function_exported?(GoodanalyticsEx, :get_link_stats, 2)
    end

    test "visitors operations" do
      assert function_exported?(GoodanalyticsEx, :list_visitors, 1)
      assert function_exported?(GoodanalyticsEx, :get_visitor, 2)
      assert function_exported?(GoodanalyticsEx, :lookup_visitor, 2)
      assert function_exported?(GoodanalyticsEx, :get_visitor_attribution, 2)
      assert function_exported?(GoodanalyticsEx, :get_visitor_timeline, 2)
    end

    test "events operations" do
      assert function_exported?(GoodanalyticsEx, :create_event, 2)
      assert function_exported?(GoodanalyticsEx, :batch_events, 2)
    end

    test "analytics operations" do
      assert function_exported?(GoodanalyticsEx, :analytics_breakdown, 1)
      assert function_exported?(GoodanalyticsEx, :analytics_timeseries, 1)
      assert function_exported?(GoodanalyticsEx, :analytics_summary, 1)
      # hand-written arity-2 wrappers that carry query params
      assert function_exported?(GoodanalyticsEx, :analytics_breakdown, 2)
      assert function_exported?(GoodanalyticsEx, :analytics_timeseries, 2)
      assert function_exported?(GoodanalyticsEx, :analytics_summary, 2)
    end

    test "partners operations" do
      assert function_exported?(GoodanalyticsEx, :list_partners, 1)
      assert function_exported?(GoodanalyticsEx, :create_partner, 2)
      assert function_exported?(GoodanalyticsEx, :get_partner, 2)
      assert function_exported?(GoodanalyticsEx, :update_partner, 3)
      assert function_exported?(GoodanalyticsEx, :update_partner_2, 3)
      assert function_exported?(GoodanalyticsEx, :archive_partner, 2)
    end
  end

  describe "analytics wrappers send query params" do
    setup do
      client = %Client{
        base_url: "https://x.test/ga/api",
        auth: {:bearer, "sk_test"},
        req_options: [plug: {Req.Test, __MODULE__}]
      }

      {:ok, client: client}
    end

    test "analytics_breakdown sends dimension/from/to as query params", %{client: client} do
      Req.Test.stub(__MODULE__, fn conn ->
        assert conn.method == "GET"
        assert String.ends_with?(conn.request_path, "/analytics/breakdown")
        q = URI.decode_query(conn.query_string)
        assert q["dimension"] == "device_type"
        assert q["from"] == "2026-06-01T00:00:00Z"
        assert q["to"] == "2026-06-30T00:00:00Z"

        Req.Test.json(conn, %{
          "dimension" => "device_type",
          "metrics" => ["events"],
          "rows" => []
        })
      end)

      assert {:ok, %GoodanalyticsEx.Schemas.BreakdownResponse{}} =
               GoodanalyticsEx.analytics_breakdown(client, %{
                 dimension: "device_type",
                 from: "2026-06-01T00:00:00Z",
                 to: "2026-06-30T00:00:00Z",
                 metrics: "events"
               })
    end

    test "analytics_timeseries sends metric/from/to as query params", %{client: client} do
      Req.Test.stub(__MODULE__, fn conn ->
        assert conn.method == "GET"
        assert String.ends_with?(conn.request_path, "/analytics/timeseries")
        q = URI.decode_query(conn.query_string)
        assert q["metric"] == "visitors"
        assert q["from"] == "2026-06-01T00:00:00Z"
        assert q["to"] == "2026-06-30T00:00:00Z"

        Req.Test.json(conn, %{
          "metric" => "visitors",
          "interval" => "day",
          "timezone" => "UTC",
          "points" => []
        })
      end)

      assert {:ok, %GoodanalyticsEx.Schemas.TimeseriesResponse{}} =
               GoodanalyticsEx.analytics_timeseries(client, %{
                 metric: "visitors",
                 from: "2026-06-01T00:00:00Z",
                 to: "2026-06-30T00:00:00Z"
               })
    end

    test "analytics_summary sends from/to as query params", %{client: client} do
      Req.Test.stub(__MODULE__, fn conn ->
        assert conn.method == "GET"
        assert String.ends_with?(conn.request_path, "/analytics/summary")
        q = URI.decode_query(conn.query_string)
        assert q["from"] == "2026-06-01T00:00:00Z"
        assert q["to"] == "2026-06-30T00:00:00Z"

        Req.Test.json(conn, %{
          "visitors" => 100,
          "new_visitors" => 40,
          "pageviews" => 300,
          "revenue" => 0,
          "identification_rate" => 0.5,
          "sessions" => 120,
          "bounce_rate" => 0.3,
          "avg_duration" => 60.0,
          "engaged_rate" => 0.7
        })
      end)

      assert {:ok, %GoodanalyticsEx.Schemas.AnalyticsSummaryResponse{}} =
               GoodanalyticsEx.analytics_summary(client, %{
                 from: "2026-06-01T00:00:00Z",
                 to: "2026-06-30T00:00:00Z"
               })
    end
  end
end
