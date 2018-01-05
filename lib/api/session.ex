defmodule DriveWealth.Session do
  use Tesla, docs: false
  @moduledoc """
  Documentation for DriveWealth Session, see http://developer.drivewealth.com "SESSIONS" section for more documentation.
  """

  plug Tesla.Middleware.BaseUrl, "https://api.drivewealth.net/v1"
  plug Tesla.Middleware.JSON

  adapter Tesla.Adapter.Hackney

  @doc """
  Create a session (http://developer.drivewealth.com/docs/create-session)

  ## Parameters

    - username: String that represents the name username.
    - password: String that represents the name password
    - opts: Map with options, look http://developer.drivewealth.com/docs/create-session.

  ## Examples

      iex> DriveWealth.Session.create_session("my_user", "my_pass")
      {:ok, %{"accounts" => [%{"maxOrderNotionalValue" => 0, "patternDayTrades" => 0,
                  "bodUpdatedWhen" => "2018-01-04T09:43:10.528Z",
                  "bodMoneyMarket" => 100.92,
                  "commissionID" => "000-3940-432f-b0e6-334adfb443f8",
                  "rtCashAvailForTrading" => 521.92, "rtCashAvailForWith" => 100,
                  "commissionSchedule" => %{"baseRate" => 2.99, "baseShares" => 239,
                    "excessRate" => 0.0125, "fractionalRate" => 0.99,
                    "passThroughFees" => false, "shareAmountRounding" => "NEAREST",
                    "subscription" => false}, "positions" => [],
                  "openedWhen" => "2017-08-02T04:56:46Z", "restricted" => false,
                  "specialOrderEnabled" => false, "interestFree" => false,
                  "accountNo" => "DWTQ000000", "bodCashAvailForTrading" => 100,
                  "bodCash" => 200.92, "gfvPdtExempt" => false,
                  "updatedWhen" => "2018-01-02T20:49:43.080Z",
                  "nickname" => "Marcos's Self Directed Account",
                  "bodEquityValue" => 200.02, "accountMgmtType" => 0,
                  "bodCashAvailForWith" => 100.92, "accountType" => 2, "sweepInd" => true,
                  "orders" => [], "longOnly" => true, "status" => 2,
                  "accountID" => "54e84319-00-40c-000-ba6c444005dd.114129806183",
                  "cash" => 5521.92, "margin" => 1,
                  "userID" => "54e84319-000-455c-000-ba6c115c85dd",
                  "buyingPowerOverride" => false,
                  "createdWhen" => "2017-08-02T04:56:46.183Z", "tradingType" => "C",
                  "currencyID" => "USD", "ibID" => "52a9356f-asd-124f-ae60-09d54241e961",
                  "freeTradeBalance" => 0, "goodFaithViolations" => 0, "maxOrderQty" => 0}],
               "appTypeID" => 2000,
               "authToken" => "54e84319-70d5-45fc-a154-1243123asd.2018-01-05T09:21:25.621Z",
               "commissionRate" => 2.99, "guest" => false, "instruments" => [],
               "loginState" => 1, "referralCode" => "2CE64F",
               "sessionKey" => "54e84319-70d5-000-343-basdf5c85dd.2018-01-05T09:21:25.621Z",
               "userID" => "54e84319-32432-45fc-sdf4-ba6c2sdf85dd", "wlpID" => "DW"}}

      iex> DriveWealth.Session.create_session("my_user", "my_pass")
      {:error, "Username and Password do not match.  Please try again."}

  """
  @spec create_session(String.t(), String.t(), Map.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def create_session(username, password, opts \\ %{
    "appTypeID" => "2000",
    "appVersion" => "0.1",
    "ipAddress" => "1.1.1.1",
    "languageID" => "en_US",
    "osVersion" => "iOS 9.1",
    "osType" => "iOS",
    "scrRes" => "1920x1080",
  }) do

    "/userSessions"
    |> post(Map.merge(%{"username" => username, "password" => password}, opts))
    |> validate_request
  end

  def get_session("") do
    {:error, "Session is empty"}
  end

  @doc """
  Get a session. (http://developer.drivewealth.com/docs/get-session)
  """
  @spec get_session(String.t()) :: {:ok, Map.t()} | {:error, String.t()}
  def get_session(session) do
    "/userSessions/" <> session
    |> get(headers: %{"x-mysolomeo-session-key" => session})
    |> validate_request
  end


  def get_session!("") do
    {:error, "Session is empty"}
  end

  @doc false
  @spec get_session!(String.t()) :: Map.t() | :error
  def get_session!(session) do
    session
    |> get_session
    |> validate_request!
  end


  def get_session!("", _username, _password) do
    {:error, "Session is empty"}
  end

  @doc """
  Custom Function to Get session or create if it's invalid
  """
  @spec get_session!(String.t(), String.t(), String.t()) :: Map.t() | :error
  def get_session!(session, username, password) do
    case get_session(session) do
      {:ok, body} ->
        body
      {:error, _message} ->
        username |> create_session(password)
        |> validate_request!
    end
  end

  @doc """
  Destroy a session, Logout. (http://developer.drivewealth.com/docs/cancel-session)
  """
  @spec destroy_session(String.t()) :: {:ok, bitstring()} | {:error, String.t()}
  def destroy_session(session) do
    "/userSessions/" <> session
    |> delete(headers: %{"x-mysolomeo-session-key" => session})
    |> validate_request
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
