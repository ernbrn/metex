defmodule Metex do
  alias Metex.Weather

  defdelegate temperatures_of(cities), to: Weather
end
