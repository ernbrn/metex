defmodule Metex.Weather do
  alias Metex.{Worker, Coordinator}

  def temperatures_of(cities) do
    coordinator_pid = spawn(Coordinator, :loop, [[], Enum.count(cities)])

    cities
    |> Enum.each(fn city ->
      spawn(Worker, :loop, [])
      |> send({coordinator_pid, city})
    end)
  end
end
