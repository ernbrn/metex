defmodule Metex.Worker do
  @api_key "5fdc4b227d087ca935060f28aecc33a6"

  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})

      _ ->
        IO.puts("I don't know how to process this message")
    end

    loop()
  end

  ## private ##

  defp temperature_of(location) do
    location
    |> url_for()
    |> HTTPoison.get()
    |> parse_response()
    |> response_message(location)
  end

  defp response_message({:ok, temp}, location) do
    "#{location}: #{temp} degrees K"
  end

  defp response_message(_, location) do
    "#{location} not found"
  end

  defp url_for(location) do
    location
    |> URI.encode()
    |> build_url
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode!() |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp build_url(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{@api_key}"
  end

  defp compute_temperature(json) do
    try do
      json["main"]["temp"] |> Float.round(1) |> ok_response()
    rescue
      _ -> :error
    end
  end

  defp ok_response(temp) do
    {:ok, temp}
  end
end
