use Croma

defmodule RankingVoteAppWeb.ClearController do
  use RankingVoteAppWeb, :controller
  alias Croma.Result, as: R
  alias Diplomat.Transaction

  def index(conn, _params) do
    result = "SELECT * FROM Vote"
             |> Diplomat.Query.new()
             |> Diplomat.Query.execute()
             |> Enum.map(fn x -> Transaction.begin |> Transaction.delete(x.key) |> Transaction.commit end)
             |> R.sequence()
    case result do
      {:error, _} ->
        json conn, %{error: "internal error"}
      {:ok, _} ->
        json conn, %{ok: "ok"}
    end
  end

end
