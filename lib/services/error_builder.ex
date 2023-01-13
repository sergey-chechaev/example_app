defmodule Services.ErrorBuilder do
  @moduledoc """
  Wrap error into Ecto.Changeset struct
  """

  import Logger
  alias Ecto.Changeset

  def call(error, module) do
    if Application.get_env(:pushsms, :env) != :test do
      Logger.error(%{module: module, description: error})
    end

    call(error)
  end

  def call({key, message}),
    do: %Changeset{types: Map.new([{:key, :string}])} |> Changeset.add_error(key, message)

  def call(%Changeset{} = error), do: error
end
