defmodule Select do
  def parse(string) do
    {"xyz", %{}, children} = do_parse(:mochiweb_html.parse("<xyz>" <> string))
    children
  end

  defp do_parse({name, attrs, children}) do
    {name, Enum.into(attrs, %{}), Enum.map(children, &do_parse/1)}
  end
  defp do_parse(node), do: node

  def matches?(node, func) when is_function(func, 1) do
    func.(node)
  end
  def matches?({name, _, _}, {:name, name}), do: true
  def matches?(_, {:name, _}), do: false
  def matches?({_, attrs, _}, {:attr, attr}) do
    Map.has_key?(attrs, attr)
  end
  def matches?(_, {:attr, _}), do: false
  def matches?({_, attrs, _}, {:attr, attr, value}) do
    attrs[attr] == value
  end
  def matches?(_, {:attr, _, _}), do: false
  def matches?(node, {:and, a, b}), do: matches?(node, a) and matches?(node, b)
  def matches?(node, {:or, a, b}), do: matches?(node, a) or matches?(node, b)
  def matches?(node, {:not, a}), do: not matches?(node, a)
  def matches?({_, attrs, _}, {:class, class}) do
    case Map.get(attrs, "class") do
      nil -> false
      classes -> classes |> String.split |> Enum.any?(&(&1 == class))
    end
  end
  def matches?(_, {:class, _}), do: false
  def matches?({_, _, _}, :element), do: true
  def matches?(_, :element), do: false
  def matches?(binary, :text) when is_binary(binary), do: true
  def matches?(_, :text), do: false
  def matches?({:comment, _}, :comment), do: true
  def matches?(_, :comment), do: false

  def find(nodes, [_|_] = matchers) do
    Enum.reduce matchers, nodes, fn matcher, nodes ->
      find(nodes, matcher)
    end
  end
  def find(nodes, matcher) when is_list(nodes) do
    Enum.flat_map(nodes, &find(&1, matcher))
  end
  def find({_, _, children} = node, matcher) do
    if(matches?(node, matcher), do: [node], else: []) ++ find(children, matcher)
  end
  def find(node, matcher) do
    if(matches?(node, matcher), do: [node], else: [])
  end

  def filter(nodes, matcher) when is_list(nodes) do
    Enum.filter(nodes, &matches?(&1, matcher))
  end
  def filter(node, matcher) do
    if(matches?(node, matcher), do: [node], else: [])
  end

  def text(nodes) when is_list(nodes), do: Enum.map_join(nodes, &text/1)
  def text({_, _, children}), do: Enum.map_join(children, &text/1)
  def text({:comment, _}), do: ""
  def text(string), do: string

  def html(nodes) when is_list(nodes), do: Enum.map(nodes, &html/1)
  def html({_, _, _} = node), do: :mochiweb_html.to_html(do_html(node))
  def html({:comment, _} = node), do: :mochiweb_html.to_html(node)
  def html(string), do: string

  defp do_html({name, attrs, children}) do
    {name, Enum.to_list(attrs), Enum.map(children, &do_html/1)}
  end
  defp do_html(node), do: node

  def prewalk(nodes, func) when is_list(nodes) and is_function(func, 1) do
    Enum.flat_map(nodes, &prewalk(&1, func))
  end
  def prewalk(node, func) when is_function(func, 1) do
    case func.(node) do
      nil -> []
      nodes when is_list(nodes) -> Enum.flat_map(nodes, &prewalk(&1, func))
      {name, attrs, children} ->
        [{name, attrs, Enum.flat_map(children, &prewalk(&1, func))}]
      otherwise -> [otherwise]
    end
  end
end
