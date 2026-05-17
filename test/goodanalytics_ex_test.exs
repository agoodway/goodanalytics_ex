defmodule GoodanalyticsExTest do
  use ExUnit.Case

  alias CanOpener.Client

  test "creates an API client with defaults" do
    assert %Client{base_url: "https://goodanalytics.dev", auth: nil} = GoodanalyticsEx.client()
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
  end
end
