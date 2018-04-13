use Croma

defmodule RankingVoteAppWeb.ResultController do
  use RankingVoteAppWeb, :controller

  def index(conn, _params) do
    result = "SELECT * FROM Vote"
             |> Diplomat.Query.new()
             |> Diplomat.Query.execute()
             |> Enum.map(fn %{properties: p} -> Enum.filter(p, fn {k, _v} ->
               String.starts_with?(k, "candidate_") end)
             end)
             |> Enum.concat()
             |> Enum.reduce(%{}, fn ({c, %{value: v}}, acc) ->
               Map.update(acc, c, v, &(&1 + v))
             end)
    
    json conn, result
  end

end
