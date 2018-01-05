defmodule DriveWealth.Account do
  use Tesla, docs: false
  @moduledoc """
  Documentation for DriveWealth Account, see http://developer.drivewealth.com "ACCOUNTS" section for more documentation.
  """

  plug Tesla.Middleware.BaseUrl, "https://api.drivewealth.net/v1"
  plug Tesla.Middleware.JSON

  adapter Tesla.Adapter.Hackney

  @doc """
  Return the account performance (http://developer.drivewealth.com/docs/account-performance)

  ## Parameters

    - userID: String that represents the name username.
    - accountID: String that represents the name password

  ## Examples

      iex> DriveWealth.Account.account_performance("session_key", "user_id", "account_id")
      {:ok,
       %{"accountID" => "54e84319-123-45fc-124-ba6c284485dd.1501649806183",
         "accountNo" => "DWT1000000", "endDate" => "2018-01-05",
         "lastUpdated" => "2018-01-05T07:58:03.562Z",
         "performance" => [%{"cash" => 1521.92, "cumRealizedPL" => 628.35,
            "date" => "2018-01-04", "deposits" => 5844.2, "equity" => 3873.55,
            "fees" => -41.65, "realizedDayPL" => 0, "unrealizedDayPL" => -46.55,
            "withdrawals" => -1035}], "startDate" => "2018-01-04"}}


      iex> DriveWealth.Account.account_performance("session_id_invalid", "account_number", "date_start", "date_end")
      {:error, "Invalid Session."}

  """
  @spec account_performance(String.t(), String.t(), String.t()) :: {:ok, Map.t()} | {:error, String.t()} | {:error, Map.t()}
  def account_performance(session_key, user_id, account_id) do
    "/users/" <> user_id <> "/accountPerformance/" <> account_id <> "/"
    |> get(headers: %{"x-mysolomeo-session-key" => session_key})
    |> validate_request
  end

  @doc false
  def account_performance!(session_key, user_id, account_id) do
    session_key
    |> account_performance(user_id, account_id)
    |> validate_request!
  end
  
  defp validate_request(response) do
    case response.status do
      200 -> {:ok, response.body}
      _ -> {:error, response.body["message"]}
    end
  end

  defp validate_request!(formated_response) do
    case formated_response do
      {:ok, body} -> body
      {:error, _} -> :error
    end
  end
end
