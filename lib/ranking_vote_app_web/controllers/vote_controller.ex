use Croma

defmodule RankingVoteAppWeb.VoteController do
  use RankingVoteAppWeb, :controller
  alias Croma.Result, as: R

  def create(conn, params) do
    result = params
             |> check_keys()
             |> R.bind(&check_values/1)
             |> R.bind(&append_datetime/1)
             |> R.bind(&(Diplomat.Entity.new(&1, "Vote") |> R.pure()))
             |> R.bind(&Diplomat.Entity.insert/1)
             |> handle_result()
    json conn, result
  end

  defp check_keys(params) do
    params
    |> Enum.reduce([], fn ({k, _v}, acc) ->
      case String.split(k, "_") do
        ["candidate", id] ->
          case Integer.parse(id) do
            {_n, ""} -> acc
            _        -> [k | acc]
          end
        _ -> [k | acc]
      end
    end)
    |> case do
      []   -> {:ok   , params              }
      list -> {:error, {:invalid_key, list}}
    end
  end

  defp check_values(params) do
    Enum.reduce_while(params, %{}, fn
      ({k, v}, acc) when is_integer(v) -> {:cont, Map.put(acc, k, v)}
      ({k, v}, acc) ->
        case Integer.parse(v) do
          {n, ""} -> {:cont, Map.put(acc, k, n)}
          _       -> {:halt, :error            }
        end
    end)
    |> case do
      :error -> {:error, :not_integer_value}
      result -> {:ok   , result            }
    end
  end

  defp append_datetime(params) do
    datetime = DateTime.utc_now()
    Map.put(params, :created_at, datetime) |> R.pure()
  end

  defp handle_result({:error, {:invalid_key, list}}), do: %{status: :error, error: :invalid_key, invalid_keys: list}
  defp handle_result({:error, :not_integer_value}  ), do: %{status: :error, error: :not_integer_value              }
  defp handle_result([]                            ), do: %{status: :error, error: :insert_error                   }
  defp handle_result([result]                      ), do: %{status: :ok   , id: result.id                          }
  defp handle_result(other                         ), do: %{status: :error, error: :unknown_error, desc: other     }

end
