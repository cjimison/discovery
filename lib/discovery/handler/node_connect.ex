defmodule Discovery.Handler.NodeConnect do
  use Discovery.Handler.Behaviour
  @passing "passing"
  @critical "critical"
  @warning "warning"

  def update_services([]), do: :ok
  def update_services([%Discovery.Service{status: @passing} = service|rest]) do
    name = node_name(service)
    unless name == Node.self do
      connect(name)
    end
    update_services(rest)
  end
  def update_services([%Discovery.Service{status: _}|rest]), do: update_services(rest)

  #
  # Private API
  #

  defp connect(name) do
    case Node.connect(name) do
      true ->
        IO.puts "CONNECTED TO: #{name}"
      false ->
        IO.puts "FAILED TO CONNECT TO: #{name}"
      :ignored ->
        IO.puts "IGNORED CONNECT TO: #{name}"
    end
  end

  defp node_name(%Discovery.Service{name: service, node: %Discovery.Node{name: node}}) do
    binary_to_atom("#{service}@#{node}")
  end
end
