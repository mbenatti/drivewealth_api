defmodule DriveWealth.Report do
  use Tesla, docs: false
  @moduledoc """
  Documentation for DriveWealth Reports, see http://developer.drivewealth.com "REPORTS" section for more documentation.
  """

  plug Tesla.Middleware.BaseUrl, "https://reports.drivewealth.net/"
  plug Tesla.Middleware.JSON

  adapter Tesla.Adapter.Hackney

  @doc """
  Get a financial transaction in JSON format (http://developer.drivewealth.com/docs/financial-transaction)

  ## Parameters

    - session_key: String that represents the name username.
    - account_number: String that represents the name password
    - date_start: String representing the beginning of the data range in UTC format.
    - date_end: String representing the end of the data range in UTC format.
    - opts: Map with options, look http://developer.drivewealth.com/docs/financial-transaction

  ## Examples

      iex> DriveWealth.Report.financial_transaction("session_id", "account_number", "date_start", "date_end")
      {:ok, %{"accountID" => "52284319-70d5-45DD-a154-ba6c285c85dd.1501649806183",
               "accountNo" => "DWT100000", "accountType" => "2",
               "dateRange" => "2017-12-10T23:59:59.999Z,2017-12-30T23:59:59.999Z",
               "transaction" => [
                 %{"accountAmount" => 1639, "accountBalance" => 1777.13,
                  "comment" => "WIRE DEPOSIT", "currencyID" => "USD", "dnb" => false,
                  "finTranID" => "EL.a28ae64d-fb9b-4d31-a71c-2a1edc251cb0",
                  "finTranTypeID" => "CSR", "systemAmount" => 0, "tranAmount" => 1639,
                  "tranWhen" => "2017-12-12T14:23:42.568Z", "wlpAmount" => 0,
                  "wlpFinTranTypeID" => "5f2a5b20-4de3-43a8-94b2-b7e341003d19"}
                   ]
                 }
               }

      iex> DriveWealth.Report.financial_transaction("session_id_invalid", "account_number", "date_start", "date_end")
      {:error, "Invalid Session."}

  """
  @spec financial_transaction(String.t(), String.t(), String.t(), String.t(), Map.t()) :: {:ok, Map.t()} | {:ok, String.t()} | {:error, String.t()} | {:error, Map.t()}
  def financial_transaction(session_key, account_number, date_start, date_end, opts \\ %{
    "ReportFormat" => "JSON"
  }) do

    params =
      %{
        "ReportName" => "FinTrans", "sessionKey" => session_key,
        "AccountNumber" => account_number, "DateStart" => date_start,
        "DateEnd" => date_end
        }

    "/DriveWealth"
    |> post("", query: Map.merge(params, opts), headers: %{"x-mysolomeo-session-key" => session_key})
    |> validate_request
  end

  @doc false
  def financial_transaction!(session_key, account_number, date_start, date_end, opts \\ %{
    "ReportFormat" => "JSON"
  }) do

    session_key
    |> financial_transaction(account_number, date_start, date_end, opts)
    |> validate_request!
  end
  
  defp validate_request(response) do
    case response.status do
      200 -> {:ok, response.body}
      _ -> {:error, response.body}
    end
  end

  defp validate_request!(formated_response) do
    case formated_response do
      {:ok, body} -> body
      {:error, _} -> :error
    end
  end
end
