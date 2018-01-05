defmodule DriveWealth.Session do
  use Tesla
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
      {:ok, %{"sessionKey" => "54e84319-70d1-45fc-a154-ba6c085c85dd.2018-01-05T04:33:14.358Z"}

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
