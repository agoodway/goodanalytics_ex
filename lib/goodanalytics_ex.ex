defmodule GoodanalyticsEx do
  @moduledoc """
  API client for GoodAnalytics.

  Create a client with `client/1`, then call the generated functions.

      client = GoodanalyticsEx.client(base_url: "https://goodanalytics.dev", api_key: "sk_...")

      {:ok, visitors} = GoodanalyticsEx.list_visitors(client)
  """

  use CanOpener,
    spec: "openapi.json",
    otp_app: :goodanalytics_ex,
    base_url: "https://goodanalytics.dev",
    auth: :bearer,
    path_prefix: "/ga/api/"
end
